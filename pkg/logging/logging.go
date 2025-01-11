package logging

import (
	"fmt"

	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
)

func init() {
	config := zap.NewDevelopmentConfig()
	config.EncoderConfig.EncodeLevel = zapcore.CapitalColorLevelEncoder
	logger, err := config.Build()
	if err != nil {
		panic(fmt.Sprintf("Failed to initialize DriftDetect logger: %v", err))
	}
	// ... rest of the code
} 