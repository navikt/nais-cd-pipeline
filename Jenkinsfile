node {

    try {
        stage("init") {
            git credentialsId: 'navikt-ci', url: "https://github.com/navikt/nais-cd-pipeline.git"
        }
        
        stage("deploy nais-ci") {
            build "nsync_nais-ci"
        }

        stage("deploy !prod"){
            parallel (
                "preprod-fss" : {
                    build "nsync_preprod-fss"
                },
                "preprod-sbs" : {
                    build "nsync_preprod-sbs"
                }
            )
        }

        slackSend channel: '#nais-internal', message: ":nais:-cd-pipeline ran successfully - ${env.BUILD_URL}", teamDomain: 'nav-it', tokenCredentialId: 'slack_fasit_frontend'

    } catch (e) {
        slackSend channel: '#nais-internal', message: "nais-cd-pipeline failed: ${e.getMessage()}\n${env.BUILD_URL}", teamDomain: 'nav-it', tokenCredentialId: 'slack_fasit_frontend'
    }
}
