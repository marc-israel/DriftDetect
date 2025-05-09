/*
Copyright © 2023-present, Meta Platforms, Inc. and affiliates
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

package checks

import (
	"testing"

	"github.com/marc-israel/DriftDetect/pkg/testutils"
	"github.com/stretchr/testify/require"
	"gopkg.in/yaml.v3"
)

func TestCheckVerify(t *testing.T) {

	testCases := []struct {
		name                 string
		contentStr           string
		fsysContents         map[string][]byte
		expectUnmarshalError bool
		expectVerifyError    bool
	}{
		{
			name: "Check if Regular File Exists (Yes)",
			contentStr: `msg: File does not exist,
path_exists: should-exist.txt`,
			fsysContents: map[string][]byte{"should-exist.txt": []byte("foo")},
		},
		{
			name: "Check if Regular File Exists (No)",
			contentStr: `msg: File does not exist,
path_exists: does-not-exist.txt`,
			fsysContents:      map[string][]byte{"should-exist.txt": []byte("foo")},
			expectVerifyError: true,
		},
		{
			name: "path_exists + Checksum Verification (Success)",
			contentStr: `msg: File does not exists or does not have expected content,
path_exists: should-exist.txt
checksum:
  sha256: 2c26b46b68ffc68ff99b453c1d30413413422d706483bfa0f98a5e886266e7ae`,
			fsysContents:         map[string][]byte{"should-exist.txt": []byte("foo")},
			expectUnmarshalError: false,
			expectVerifyError:    false,
		},
		{
			name: "Check if Checksum is Correct (Yes)",
			contentStr: `msg: File does not exists or does not have expected content,
path_exists: has-correct-hash.txt
checksum:
  sha256: 2c26b46b68ffc68ff99b453c1d30413413422d706483bfa0f98a5e886266e7ae`,
			fsysContents: map[string][]byte{"has-correct-hash.txt": []byte("foo")},
		},
		{
			name: "Check if Checksum is Correct (Yes)",
			contentStr: `msg: File does not exists or does not have expected content,
path_exists: incorrect-hash.txt
checksum:
  sha256: "absolutely wrong"`,
			fsysContents:      map[string][]byte{"incorrect-hash.txt": []byte("foo")},
			expectVerifyError: true,
		},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			// prep filesystem
			fsys, err := testutils.MakeAferoTestFs(tc.fsysContents)
			require.NoError(t, err)

			// decode the check
			var check Check
			err = yaml.Unmarshal([]byte(tc.contentStr), &check)
			if tc.expectUnmarshalError {
				require.Error(t, err)
				return
			}
			require.NoError(t, err)

			// run verification
			err = check.Verify(VerificationContext{FileSystem: fsys})
			if tc.expectVerifyError {
				require.Error(t, err)
				return
			}
			require.NoError(t, err)
		})
	}

}
