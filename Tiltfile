load('ext://restart_process', 'docker_build_with_restart')

allow_k8s_contexts('k3d-dead-letter')

def generate_apply_list(directory):
    files = listdir(directory)
    filtered_files = []

    for file in files:
        if file.find("kustomize") == -1:
            filtered_files.append(file)

    return filtered_files
# rabbitmq
k8s_yaml(generate_apply_list('./manifests/rabbitmq'))
