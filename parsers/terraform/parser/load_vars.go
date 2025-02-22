package parser

import (
	"fmt"
	"io/ioutil"
	"strings"

	"github.com/hashicorp/hcl/v2"
	"github.com/hashicorp/hcl/v2/hclsyntax"
	hcljson "github.com/hashicorp/hcl/v2/json"
	"github.com/zclconf/go-cty/cty"
)

func loadTFVars(filenames []string) (map[string]cty.Value, error) {
	combinedVars := make(map[string]cty.Value)

	for _, filename := range filenames {
		vars, err := loadTFVarsFile(filename)
		if err != nil {
			return nil, fmt.Errorf("failed to load tfvars from %s: %w", filename, err)
		}
		for k, v := range vars {
			combinedVars[k] = v
		}
	}

	return combinedVars, nil
}

func loadTFVarsFile(filename string) (map[string]cty.Value, error) {

	inputVars := make(map[string]cty.Value)
	if filename == "" {
		return inputVars, nil
	}

	src, err := ioutil.ReadFile(filename)
	if err != nil {
		return nil, err
	}

	var attrs hcl.Attributes
	if strings.HasSuffix(filename, ".json") {
		variableFile, err := hcljson.Parse(src, filename)
		if err != nil {
			return nil, err
		}
		attrs, err = variableFile.Body.JustAttributes()
		if err != nil {
			return nil, err
		}
	} else {
		variableFile, err := hclsyntax.ParseConfig(src, filename, hcl.Pos{Line: 1, Column: 1})
		if err != nil {
			return nil, err
		}
		attrs, err = variableFile.Body.JustAttributes()
		if err != nil {
			return nil, err
		}
	}

	for _, attr := range attrs {
		inputVars[attr.Name], _ = attr.Expr.Value(&hcl.EvalContext{})
	}

	return inputVars, nil
}
