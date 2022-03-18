package formatters

import (
	"bytes"
	"testing"

	"github.com/aquasecurity/defsec/parsers/types"
	"github.com/aquasecurity/defsec/providers"
	"github.com/aquasecurity/defsec/providers/aws/dynamodb"
	"github.com/aquasecurity/defsec/rules"
	"github.com/aquasecurity/defsec/severity"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func Test_JSON(t *testing.T) {
	want := `{
	"results": [
		{
			"rule_id": "AVD-AA-9999",
			"long_id": "aws-dynamodb-enable-at-rest-encryption",
			"rule_description": "summary",
			"rule_provider": "aws",
			"rule_service": "dynamodb",
			"impact": "impact",
			"resolution": "resolution",
			"links": [
				"https://google.com"
			],
			"description": "Cluster encryption is not enabled.",
			"severity": "HIGH",
			"status": 0,
			"resource": "",
			"location": {
				"filename": "test.test",
				"start_line": 123,
				"end_line": 123
			}
		}
	]
}
`
	buffer := bytes.NewBuffer([]byte{})
	formatter := New().AsJSON().WithWriter(buffer).Build()
	var results rules.Results
	results.Add("Cluster encryption is not enabled.",
		dynamodb.ServerSideEncryption{
			Metadata: types.NewTestMetadata(),
			Enabled:  types.Bool(false, types.NewTestMetadata()),
		})
	results.SetRule(rules.Rule{
		AVDID:       "AVD-AA-9999",
		LegacyID:    "AAA999",
		ShortCode:   "enable-at-rest-encryption",
		Summary:     "summary",
		Explanation: "explanation",
		Impact:      "impact",
		Resolution:  "resolution",
		Provider:    providers.AWSProvider,
		Service:     "dynamodb",
		Links: []string{
			"https://google.com",
		},
		Severity: severity.High,
	})
	require.NoError(t, formatter.Output(results))
	assert.Equal(t, want, buffer.String())
}