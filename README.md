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
- Run `tilt up` to bring up all services & resources on the local cluster
    - The `Tiltfile` manifest expects the Kubernetes context to be named `k3d-dead-letter`
