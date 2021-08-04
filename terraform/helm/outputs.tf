output "Name_of_the_release" {
  value = helm_release.helm_deploy.name
}


output "Name_of_the_chart" {
    value = helm_release.helm_deploy.chart
}

output "Namespace" {
  value = helm_release.helm_deploy.namespace
}


output "metadata" {
  value = data.kubernetes_service.helm_deploy.metadata
}

output "status" {
  value = data.kubernetes_service.helm_deploy.status
}

output "spec" {
  value = data.kubernetes_service.helm_deploy.spec
}

output "ingressendpoint" {
  value = data.kubernetes_ingress.helm_ingress.status[0].load_balancer[0].ingress[0].hostname
}
