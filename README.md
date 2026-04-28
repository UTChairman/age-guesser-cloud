# Age Guesser: The Ultimate DevOps & GitOps Cloud Odyssey

## 🚀 Project Overview
This project is a high-fidelity demonstration of a modern, automated microservices ecosystem. It features a dual-tier **Age Guesser** application—a Node.js/Express backend integrated with an external API (Agify.io) and a sleek, responsive frontend. 

The core value of this project lies in its **Zero-Touch Deployment** philosophy. Every component, from the virtual hardware on AWS to the software configuration and the live application orchestration, was deployed using code.

---

## 🛠️ Tech Stack & Architecture

### **Layer 1: The Infrastructure (IaC)**
*   **Terraform**: Orchestrated the provisioning of AWS VPCs, Security Groups, and EC2 instances. 
*   **AWS Cloud**: Leveraged EC2 `t3.small` instances for a balance of cost and performance.

### **Layer 2: Configuration Management**
*   **Ansible**: Automated the server "hardening" and software installation (Docker & K3s) across the remote fleet.

### **Layer 3: Orchestration & Containerization**
*   **Docker**: Encapsulated microservices into lightweight, immutable images.
*   **Kubernetes (k3s)**: Managed container lifecycle, health checks, and internal service discovery.

### **Layer 4: CI/CD & GitOps**
*   **GitHub Actions**: Automated Docker builds and manifest patching on every `git push`.
*   **ArgoCD**: Implemented the GitOps pattern, ensuring the cluster state always matches the repository.

---

## 📂 Project Scaffolding
```text
.
├── .github/workflows/      # CI/CD Pipeline definitions
│   └── deploy.yml          # Build & Push workflow
├── age-guesser/            # Source Code
│   ├── backend/            # Express.js API
│   │   ├── server.js
│   │   └── Dockerfile
│   └── frontend/           # Static Web Server
│       ├── public/index.html
│       ├── server.js
│       └── Dockerfile
├── ansible/                # Configuration Management
│   ├── inventory.ini       # Remote server targets
│   └── playbook.yml        # Automation logic
├── k8s/                    # Kubernetes Manifests
│   ├── backend-deployment.yaml
│   ├── backend-service.yaml
│   ├── frontend-deployment.yaml
│   └── frontend-service.yaml
├── terraform/              # Infrastructure as Code
│   └── main.tf             # AWS Resource definitions
├── .gitignore              # Git exclusion rules
└── README.md               # This documentation
```

---

## 🔧 Critical Challenges & Professional Solutions

### 1. The "Free Tier" Memory Trap
*   **Issue**: Kubernetes (even lightweight k3s) requires a minimum baseline of RAM. On a standard AWS `t3.micro` (1GB RAM), the API server would frequently freeze or "hang" during namespace creation.
*   **Solution**: 
    1.  **Hardware Upgrade**: Upgraded the instance to `t3.small` (2GB RAM) in the AWS Console and synchronized the change back to the `main.tf` Terraform code.
    2.  **Emergency Swap**: Implemented a **2GB Linux Swapfile** to provide virtual memory overhead, preventing OOM (Out Of Memory) kills.

### 2. The "Pre-Receive Hook" Large File Block
*   **Issue**: During the initial `git push`, the hidden `.terraform` folder (containing 800MB+ of provider binaries) was accidentally staged, causing GitHub to reject the entire push.
*   **Solution**: 
    1.  Created a robust `.gitignore` file.
    2.  Performed a **Git Reset** by deleting the `.git` folder and re-initializing the repository. This purged the large files from the history and reduced the push size from 800MB to <2MB.

### 3. Port Conflicts with Traefik
*   **Issue**: K3s comes with Traefik as the default ingress controller, which occupies ports 80 and 443. This caused a conflict when trying to expose ArgoCD on the same ports, resulting in `404 Page Not Found` errors.
*   **Solution**: Switched the ArgoCD service to use **NodePorts**. By accessing the dashboard through high-range ports (e.g., `32478`), we bypassed the Traefik conflict without needing complex ingress rules.

### 4. Manifest Placeholder Sync
*   **Issue**: The K8s manifests originally used a placeholder `DOCKERHUB_USERNAME`, which caused `InvalidImageName` errors in the cluster.
*   **Solution**: Integrated a `sed` replacement step in the GitHub Actions pipeline and manually updated the local manifests to point to the real DockerHub account (`umartanvir007`).

---

## 📸 Project Milestones (Screenshots)

Inside the `various screenshots` folder, we have documented the following critical phases:

*   **[Step 1: Cluster Health Check](various screenshots/Screenshot 2026-04-28 143402.png)**: Validating the internal Kubernetes services using `kubectl`.
*   **[Step 2: GitOps Integration](various screenshots/Screenshot 2026-04-28 143739.png)**: Setting up the ArgoCD application to monitor our GitHub repository.
*   **[Step 3: The Green Wall](various screenshots/Screenshot 2026-04-28 150419.png)**: ArgoCD showing a fully synced, healthy, and operational microservices tree.
*   **[Step 4: Image Factory](various screenshots/Screenshot 2026-04-28 150446.png)**: Docker Desktop history showing the successful builds of the frontend and backend containers.
*   **[Step 5: Production Launch](various screenshots/Screenshot 2026-04-28 150516.png)**: The Age Guesser landing page successfully serving traffic from AWS.
*   **[Step 6: End-to-End Success](various screenshots/Screenshot 2026-04-28 150535.png)**: Demonstrating the full logic flow where the app correctly predicts the age of a user in real-time.

---

## 🏁 Final Conclusion
This project demonstrates that DevOps is not just about tools, but about the **integration** of those tools. By overcoming significant resource constraints and networking hurdles, we successfully created a production-grade environment on a budget. The result is a resilient, automated, and easily reproducible cloud application.
