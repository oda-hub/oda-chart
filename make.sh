echo -e "\033[32musing ODA_NAMESPACE=${ODA_NAMESPACE:=oda-staging}\033[0m"
echo -e "\033[32musing ODA_SITE=${ODA_SITE:-}\033[0m"

function create-namespace() {
    if kubectl get namespace ${ODA_NAMESPACE} >/dev/null 2>&1; then
        echo 'namespace is present'
    else
        kubectl create namespace ${ODA_NAMESPACE}
    fi
}


function site-values() {
    if [ "${ODA_SITE}" == "" ]; then
        echo values.yaml
    else
        echo values-${ODA_SITE}.yaml
    fi
}

function create-secrets(){
    echo
#    kubectl create secret generic db-user-pass  --from-file=./private/password.txt
#    kubectl create secret generic minio-key  --from-file=./private/minio-key.txt
#    kubectl create secret generic jena-password  --from-file=./private/jena-password.txt
#    kubectl create secret generic logstash-entrypoint  --from-file=./private/logstash-entrypoint.txt
}

function upgrade-dev() {
    set -x
    helm upgrade -i -n ${ODA_NAMESPACE:?} oda . \
        -f $(site-values) \
        --set dqueue.image.tag="$(cd charts/dqueue-chart/dqueue; git describe --always)" \
        --set dda.image.tag="$(cd charts/dda-chart/dda; git describe --always)" \
        --set magic.image.tag="$(cd charts/magic-chart/magic-container; git describe --always)" \
        --set dispatcher.image.tag="$(cd charts/dispatcher-chart/dispatcher; git describe --always)" \
        --set dda.securityContext.runAsUser=5182 \
        --set dda.securityContext.runAsGroup=4700 \
        --set dispatcher.securityContext.runAsUser=5182 \
        --set dispatcher.securityContext.runAsGroup=4700
}

function upgrade() {
    set -x
    helm upgrade --install  oda . 
}

function recreate-dev() {
    kubectl delete namespace $ODA_NAMESPACE
    kubectl create namespace $ODA_NAMESPACE

    make create-secrets
    upgrade-dev
}

function test() {
    upgrade-dev # or not dev!
    helm test oda -n $ODA_NAMESPACE --logs --debug
}


$@
