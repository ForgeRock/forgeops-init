// This is very experimental - use at your own risk, this may go away.
const { events, Job, Group } = require('brigadier')
const util = require('util')

const helmTag = "v2.7.2"
const forgerockRepo = "https://storage.googleapis.com/forgerock-charts"



function doTest() {
    console.log("Running test...")

    var busybox = new Job("busybox", "busybox")
    busybox.storage.enabled = false
    busybox.tasks = [
        "ls -lR /src"
    ]

    busybox.run().then( result => {
        console.log("Busybox =" + result)
    })

}

function helmUpgrade(commit) {
    console.log("Upgrade commit " + commit)
    var helm = new Job("helm", "lachlanevenson/k8s-helm:" + helmTag)
    helm.storage.enabled = false

    var upgrade = "helm upgrade --reuse-values --version 6.0.0 --set global.git.branch=" + commit + " openig forgerock/openig"

    console.log("cmd is " + upgrade)
    helm.tasks = [
       //"ls -R /src",
       "helm init --client-only",
       "helm repo add forgerock " + forgerockRepo,
       "helm search forgerock/",
       upgrade
    ]

    console.log("Running helm...")

     helm.run().then( result => {
        console.log(" Result = " + result)
     })

}

function helmInstall() {
      var helm = new Job("helm", "lachlanevenson/k8s-helm:" + helmTag)
      helm.storage.enabled = false

     helm.tasks = [
       "helm init --client-only",
       "helm repo add forgerock " + forgerockRepo,
       "helm install forgerock/openig --version 6.0.0 -f /src/helm/values.yaml --name openig"
        ];

      helm.run().then(result => {
          console.log("Helm output =" + result)
       });
}

events.on("exec", (brigadeEvent, project) => {
    console.log(util.inspect(brigadeEvent, false, null))
    console.log(util.inspect(project,false,null))
    //helmDeploy()
    var obj = JSON.parse(brigadeEvent.payload)
    helmUpgrade(obj.head)
    console.log("done")
})

events.on("push", (event,project) => {
    console.log(util.inspect(event, false, null))
    var payload = JSON.parse(event.payload) // the github event payload
    helmUpgrade(payload.after)
})

events.on("pull_request", (event,project) => {
    console.log(util.inspect(event, false, null))
    var payload = JSON.parse(event.payload)

})


events.on("error", (e) => {
    console.log("Error event " + util.inspect(e, false, null) )
     console.log("==> Event " + e.type + " caused by " + e.provider + " cause class" + e.cause)
    })

events.on("after", (e) => {  console.log("After event fired " + util.inspect(e, false, null) )})