
provider "helm" {
  debug = true
}


resource "null_resource" "download_chart" {
  depends_on = [local_file.invoke_sh]
  provisioner "local-exec" {
    interpreter = ["/bin/bash"]
    working_dir = "${path.module}"
    command     = "./invoke.sh"
  }
}

resource "local_file" "invoke_sh" {
  filename = "${path.module}/invoke.sh"
  content = templatefile(
    "${path.module}/templates/invoke.sh.tpl",
     {
        HELM_REPO     = var.HELM_REPO,
        HELM_REPO_PASSWORD = var.HELM_REPO_PASSWORD,
        setpath          = "${path.module}"
     }
  )
}

resource "null_resource" "wait_for_ingress" {
  depends_on = [local_file.invoke_sh_ingress]
  provisioner "local-exec" {
    interpreter = ["/bin/bash"]
    working_dir = "${path.module}"
    command     = "./waitforingress.sh"
  }
}

resource "local_file" "invoke_sh_ingress" {
  depends_on = [helm_release.helm_deploy]
  filename = "${path.module}/waitforingress.sh"
  content = templatefile(
    "${path.module}/templates/waitforingress.sh.tpl",
     {
        NAMESPACE       = var.HELM_NAMESPACE,
        INGRESSNAME     = "${local.helm_trim}-${var.SANDBOX_ID}",
        INGRESS_TIMEOUT = var.INGRESS_TIMEOUT
     }
  )
}




resource "helm_release" "helm_deploy" {
  depends_on = [null_resource.download_chart]
  name      = "${local.helm_trim}-${var.SANDBOX_ID}"
  atomic    = true
  namespace = var.HELM_NAMESPACE
  chart     = "${path.module}/repo/charts/${var.HELM_CHART}"
  dynamic "set" {
    for_each = local.helm_config

    content{
      name = set.key
      value = set.value
    }
  }
}


data "kubernetes_service" "helm_deploy" {
  depends_on = [helm_release.helm_deploy]
  metadata {
    name = helm_release.helm_deploy.name
    namespace = helm_release.helm_deploy.namespace
  }
}

data "kubernetes_ingress" "helm_ingress" {
  depends_on = [null_resource.wait_for_ingress]
  metadata {
    name = "${local.helm_trim}-${var.SANDBOX_ID}"
    namespace = var.HELM_NAMESPACE
  }
}