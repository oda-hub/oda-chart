## Requirements for deployment

* A kubernetes cluster, API > v1.23
  * CSI with ReadWriteMany persistent volumes
  * Ingress controler and certificate manager

### Typical minimal base platform: frontend and dispatcher + Contributed notebook backends

* 50 CPU, 100 Gb RAM, 200Gb persistent storage for container images

### HPC cluster link 

* HPC cluster, e.g. slurm scheduler, and service account (possibly serveral)
 * typical capacity 50 jobs to run at the same time
 * egress from the HPC cluster to kubernetes cluster
 * shared storage for intermediate results, 20 Tb

For breakdown and the case of INTEGRAL analysis, see [there](https://github.com/oda-hub/mmoda-manifesto/blob/main/README.md#requirements-for-deployment).
