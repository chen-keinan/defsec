package securitycenter

import (
	"testing"

	"github.com/aquasecurity/defsec/parsers/types"
	"github.com/aquasecurity/defsec/providers/azure/securitycenter"
	"github.com/aquasecurity/defsec/rules"
	"github.com/aquasecurity/defsec/state"
	"github.com/stretchr/testify/assert"
)

func TestCheckAlertOnSevereNotifications(t *testing.T) {
	tests := []struct {
		name     string
		input    securitycenter.SecurityCenter
		expected bool
	}{
		{
			name: "Security center alert nofifications disabled",
			input: securitycenter.SecurityCenter{
				Metadata: types.NewTestMetadata(),
				Contacts: []securitycenter.Contact{
					{
						Metadata:                 types.NewTestMetadata(),
						EnableAlertNotifications: types.Bool(false, types.NewTestMetadata()),
					},
				},
			},
			expected: true,
		},
		{
			name: "Security center alert nofifications enabled",
			input: securitycenter.SecurityCenter{
				Metadata: types.NewTestMetadata(),
				Contacts: []securitycenter.Contact{
					{
						Metadata:                 types.NewTestMetadata(),
						EnableAlertNotifications: types.Bool(true, types.NewTestMetadata()),
					},
				},
			},
			expected: false,
		},
	}
	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			var testState state.State
			testState.Azure.SecurityCenter = test.input
			results := CheckAlertOnSevereNotifications.Evaluate(&testState)
			var found bool
			for _, result := range results {
				if result.Status() != rules.StatusPassed && result.Rule().LongID() == CheckAlertOnSevereNotifications.Rule().LongID() {
					found = true
				}
			}
			if test.expected {
				assert.True(t, found, "Rule should have been found")
			} else {
				assert.False(t, found, "Rule should not have been found")
			}
		})
	}
}
