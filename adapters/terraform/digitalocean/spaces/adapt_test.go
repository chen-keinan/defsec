package spaces

import (
	"testing"

	"github.com/aquasecurity/defsec/adapters/terraform/testutil"

	"github.com/aquasecurity/defsec/providers/digitalocean/spaces"
)

func Test_Adapt(t *testing.T) {
	t.SkipNow()
	tests := []struct {
		name      string
		terraform string
		expected  spaces.Spaces
	}{
		{
			name: "basic",
			terraform: `
resource "" "example" {
    
}
`,
			expected: spaces.Spaces{},
		},
	}

	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			modules := testutil.CreateModulesFromSource(test.terraform, ".tf", t)
			adapted := Adapt(modules)
			testutil.AssertDefsecEqual(t, test.expected, adapted)
		})
	}
}

func Test_adaptBuckets(t *testing.T) {
	t.SkipNow()
	tests := []struct {
		name      string
		terraform string
		expected  []spaces.Bucket
	}{
		{
			name: "basic",
			terraform: `
resource "" "example" {
    
}
`,
			expected: []spaces.Bucket{},
		},
	}

	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			modules := testutil.CreateModulesFromSource(test.terraform, ".tf", t)
			adapted := adaptBuckets(modules)
			testutil.AssertDefsecEqual(t, test.expected, adapted)
		})
	}
}
