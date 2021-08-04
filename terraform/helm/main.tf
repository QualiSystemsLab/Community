
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

resource "time_sleep" "wait_in_seconds" {
  depends_on = [helm_release.helm_deploy]

  create_duration = var.WAIT_TIME
}

data "kubernetes_ingress" "helm_ingress" {
  depends_on = [time_sleep.wait_in_seconds]
  metadata {
    name = "${local.helm_trim}-${var.SANDBOX_ID}"
    namespace = var.HELM_NAMESPACE
  }
}