package blocks

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
)

type mockWriter struct {
	memory []byte
}

func (mw *mockWriter) Write(p []byte) (n int, err error) {
	mw.memory = append(mw.memory, p...)
	return len(p), nil
}

func (mw *mockWriter) GetMemory() []byte {
	return mw.memory
}

func TestBufferedWriter(t *testing.T) {
	testCases := []struct {
		name       string
		textChunks []string
		wantError  bool
	}{
		{
			name:       "Finished line",
			textChunks: []string{"Hello\n"},
			wantError:  false,
		}, {
			name:       "Unfinished line",
			textChunks: []string{"Hello, world", "!\n"},
			wantError:  false,
		}, {
			name:       "No last newline",
			textChunks: []string{"Hello,\nworld", "!\nfoobar"},
			wantError:  false,
		},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			mockWriter := &mockWriter{}
			zw := &bufferedWriter{
				writer: mockWriter,
			}
			var totalBytesWritten int
			for _, text := range tc.textChunks {
				bytesWritten, err := zw.Write([]byte(text))
				totalBytesWritten += bytesWritten
				if tc.wantError {
					assert.Error(t, err)
				} else {
					assert.NoError(t, err)
				}
			}
			zw.Close()

			expectedTotalBytesWritten := 0
			for _, text := range tc.textChunks {
				expectedTotalBytesWritten += len(text)
			}
			assert.Equal(t, expectedTotalBytesWritten, totalBytesWritten)
			expectedBytesWritten := []byte{}
			for _, text := range tc.textChunks {
				text = strings.ReplaceAll(text, "\n", "")
				expectedBytesWritten = append(expectedBytesWritten, []byte(text)...)
			}
			assert.Equal(t, expectedBytesWritten, mockWriter.GetMemory())
		})
	}
}