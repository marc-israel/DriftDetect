// ErrInvalidTTP indicates that a TTP YAML file does not conform to the DriftDetect
// TTP specification
var ErrInvalidTTP = errors.New("invalid DriftDetect TTP")

// TTP represents a DriftDetect TTP configuration
type TTP struct {
	APIVersion string `yaml:"api_version"`
	UUID       string `yaml:"uuid"`
	Name       string `yaml:"name"`
	// ... rest of the struct
} 