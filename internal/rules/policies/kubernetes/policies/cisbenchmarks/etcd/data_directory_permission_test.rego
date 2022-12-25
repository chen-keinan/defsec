package builtin.kubernetes.KCV0058

test_validate_data_directory_permission_equal_700 {
	r := deny with input as {
		"apiVersion": "v1",
		"kind": "Nodeinfo",
		"type": "master",
		"info": {"EtcdDataDirectoryPermissions": [700]},
	}

	count(r) == 0
}

test_validate_data_directory_permission_lower_700 {
	r := deny with input as {
		"apiVersion": "v1",
		"kind": "Nodeinfo",
		"type": "master",
		"info": {"EtcdDataDirectoryPermissions": [500]},
	}

	count(r) == 0
}

test_validate_data_directory_permission_higher_700 {
	r := deny with input as {
		"apiVersion": "v1",
		"kind": "Nodeinfo",
		"type": "master",
		"info": {"EtcdDataDirectoryPermissions": [755]},
	}

	count(r) == 1
}
