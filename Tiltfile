load('ext://restart_process', 'docker_build_with_restart')

allow_k8s_contexts('k3d-dead-letter')

def generate_apply_list(directory):
    files = listdir(directory)
    filtered_files = []

    for file in files:
        if file.find("kustomization") == -1:
            filtered_files.append(file)

    print(filtered_files)

    return filtered_files

# cluster resources
k8s_yaml(generate_apply_list('./manifests/cluster'))

# rabbitmq
k8s_yaml(generate_apply_list('./manifests/rabbitmq'))

# postgres
k8s_yaml(generate_apply_list('./manifests/postgres'))

# data
k8s_yaml(generate_apply_list('./manifests/data'))
