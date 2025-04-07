package test

import (
	"testing"

	helper "github.com/cloudposse/test-helpers/pkg/atmos/component-helper"
)

type ComponentSuite struct {
	helper.TestSuite
}

func (s *ComponentSuite) TestBasic() {
	const component = "github-oidc-provider/basic"
	const stack = "default-test"

	defer s.DestroyAtmosComponent(s.T(), component, stack, nil)
	s.DeployAtmosComponent(s.T(), component, stack, nil)
}

func (s *ComponentSuite) TestEnabledFlag() {
	const component = "github-oidc-provider/disabled"
	const stack = "default-test"

	s.VerifyEnabledFlag(component, stack, nil)
}

func TestRunSuite(t *testing.T) {
	suite := new(ComponentSuite)
	helper.Run(t, suite)
}
