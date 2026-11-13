resource "helm_release" "secrets_store_csi_driver" {
  name       = "csi-secrets-store"
  repository = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
  chart      = "secrets-store-csi-driver"
  version    = "1.6.1"
  namespace  = "kube-system"

  values = [
    yamlencode({
      syncSecret = {
        enabled = true
      }

      tokenRequests = [
        {
          audience = "sts.amazonaws.com"
        },
        {
          audience = "pods.eks.amazonaws.com"
        }
      ]
    })
  ]
}
