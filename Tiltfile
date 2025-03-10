load('ext://restart_process', 'docker_build_with_restart')

allow_k8s_contexts('k3d-dead-letter')

docker_build_with_restart(
	'ghcr.io/dead-letter/dead-letter-data',
	context='../dead-letter-data',
	entrypoint=["air", "-c", ".air.toml"],
	dockerfile='../dead-letter-data/Dockerfile.dev',
	extra_tag='latest',
	live_update=[
		sync('../dead-letter-data', '/app')
	]
)

docker_build_with_restart(
	'ghcr.io/dead-letter/dead-letter-order',
	context='../dead-letter-order',
	entrypoint=["python", "main.py"],
	dockerfile='../dead-letter-order/Dockerfile',
	extra_tag='latest',
	live_update=[
		sync('../dead-letter-order', '/app')
	]
)

def generate_apply_list(directory):
	files = listdir(directory)
	filtered_files = []

	for file in files:
		if file.find("kustomization") == -1:
			filtered_files.append(file)

	return filtered_files


# cluster resources
k8s_yaml(generate_apply_list('./manifests/cluster'))

# rabbitmq
k8s_yaml(generate_apply_list('./manifests/rabbitmq'))

# postgres
k8s_yaml(generate_apply_list('./manifests/postgres'))

# data
k8s_yaml(generate_apply_list('./manifests/data'))

# business-auth
k8s_yaml(generate_apply_list('./manifests/business-auth'))

# rider
k8s_yaml(generate_apply_list('./manifests/rider'))

# order
k8s_yaml(generate_apply_list('./manifests/order'))
