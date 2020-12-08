node { 
    def lastCommit
    
    try {
        stage("init") {
            git url: "https://github.com/navikt/nais-cd-pipeline.git"

            sh("rm -rf naisible nais-inventory")

            dir("nais-inventory") {
                git credentialsId: 'nais-inventory', url: "git@github.com:navikt/nais-inventory.git"
            }

            dir("naisible") {
                git url: "https://github.com/nais/naisible.git"
            }

            lastCommit = sh(script: "/bin/sh ./echo_last_commit.sh", returnStdout: true).trim()

            slackSend channel: '#nais-ci', message: "pipeline triggered:\n${lastCommit}", teamDomain: 'nav-it', tokenCredentialId: 'slack_fasit_frontend'
        }
        
        stage("deploy nais-ci") {
            build job: "nsync_nais-ci"
        }

        stage("deploy dev"){
            parallel (
                "dev-fss" : {
                    build job: "nsync_dev-fss"
                },
                "dev-sbs" : {
                    build job: "nsync_dev-sbs"
                },
            )
        }

        stage("deploy prod") {
            parallel (
                "prod-fss": {
                    build job: "nsync_prod-fss"
                },
                "prod-sbs": {
                    build job: "nsync_prod-sbs"
                }
            )
        }

        slackSend color: "good", channel: '#nais-ci', message: ":nais:-cd-pipeline ran successfully :thumbsup: ${env.BUILD_URL}", teamDomain: 'nav-it', tokenCredentialId: 'slack_fasit_frontend'

    } catch (e) {
        slackSend color: "danger", channel: '#nais-ci', message: "nais-cd-pipeline failed: ${e.getMessage()}\n${env.BUILD_URL}", teamDomain: 'nav-it', tokenCredentialId: 'slack_fasit_frontend'
    }
}
