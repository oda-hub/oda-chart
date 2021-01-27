export NAMESPACE=${NAMESPACE:-staging-1-3}

function create-secrets(){
    kubectl create secret generic db-user-pass  --from-file=./private/password.txt
    kubectl create secret generic odatests-tests-bot-password  --from-file=./private/testbot-password.txt
    kubectl create secret generic odatests-secret-key  --from-file=./private/secret-key.txt
    kubectl create secret generic minio-key  --from-file=./private/minio-key.txt
    kubectl create secret generic jena-password  --from-file=./private/jena-password.txt
    kubectl create secret generic logstash-entrypoint  --from-file=./private/logstash-entrypoint.txt
}

function upgrade-dev() {
    set -x
    helm upgrade -i -n ${NAMESPACE:?} oda . \
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


$@
