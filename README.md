# dead-letter-manifests
The manifest repository for Dead Letter

## Folder Structure
The suggested folder structure looks like:
```
./dead-letter/
├── dead-letter-manifests
│   ├── LICENSE
│   ├── manifests
│   ├── README.md
│   ├── setup
│   │   ├── setup.ps1
│   │   └── setup.sh
│   └── Tiltfile
├── dead-letter-microservice-1
└── dead-letter-microservice-2
```
## Developing
- Authenticate with the GHCR Repo using a GitHub personal access token
    - Create a PAT at [this link](https://github.com/settings/tokens)
        - admin:org
        - delete:packages
        - write:packages
        - repo
    - `echo ghp_.... | docker login ghcr.io -u USERNAME --password-stdin`
- Run `tilt up` to bring up all services & resources on the local cluster
    - The `Tiltfile` manifest expects the Kubernetes context to be named `k3d-dead-letter`
