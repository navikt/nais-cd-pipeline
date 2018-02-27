node {

    def lastCommit
    
    try {
        stage("init") {
            git credentialsId: 'navikt-ci', url: "https://github.com/navikt/nais-cd-pipeline.git"
            

            sh("rm -rf naisible nais-inventory nais-tpa nais-platform-apps")

            dir("nais-inventory") {
                git credentialsId: 'navikt-ci', url: "https://github.com/navikt/nais-inventory.git"
            }

            dir("naisible") {
                git url: "https://github.com/nais/naisible.git"
            }

            dir("nais-platform-apps") {
                git credentialsId: 'navikt-ci', url: "https://github.com/navikt/nais-platform-apps.git"
            }

            dir("nais-tpa") {
                git credentialsId: 'navikt-ci', url: "https://github.com/navikt/nais-tpa.git"
            }

            

            lastCommit = sh(script: "/bin/sh ./echo_recent_git_log.sh", returnStdout: true).trim()
            slackSend color: "good", channel: '#nais-internal', message: "testing testing, ${lastCommit}", teamDomain: 'nav-it', tokenCredentialId: 'slack_fasit_frontend'
        }
        
       // stage("deploy nais-ci") {
       //     build "nsync_nais-ci"
       // }

       // stage("deploy !prod"){
       //     parallel (
       //         "preprod-fss" : {
       //             build "nsync_preprod-fss"
       //         },
       //         "preprod-sbs" : {
       //             build "nsync_preprod-sbs"
       //         }
       //     )
       // }

       // slackSend channel: '#nais-internal', message: ":nais:-cd-pipeline ran successfully - ${env.BUILD_URL}", teamDomain: 'nav-it', tokenCredentialId: 'slack_fasit_frontend'

    } catch (e) {
        slackSend channel: '#nais-internal', message: "nais-cd-pipeline failed: ${e.getMessage()}\n${env.BUILD_URL}", teamDomain: 'nav-it', tokenCredentialId: 'slack_fasit_frontend'
    }
}
