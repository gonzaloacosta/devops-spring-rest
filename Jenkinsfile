pipeline {
    agent { label 'master' }

    options {
        ansiColor('xterm')
    }

    environment {
        REPO_SLUG                  = "${env.GIT_URL.tokenize('/')[1].tokenize('.')[0] }"
        PKR_VAR_test_mode          = "${env.BRANCH_NAME == 'main' ? 'false' : 'true'}"
        PKR_VAR_jenkins_job        = "${env.JOB_NAME}"
        PKR_VAR_jenkins_job_id     = "${env.BUILD_NUMBER}"
    }
    stages {
        stage('PreBuild Information') {
            steps {
                sh 'printenv | sort'
                // Notify job has started
                bitbucketStatusNotify(
                    buildState: 'INPROGRESS',
                    buildName: "${env.JOB_NAME}",
                    buildKey: "${env.JOB_NAME}",
                    repoSlug: "${REPO_SLUG}",
                    commitId: "${env.GIT_COMMIT}"
                )
            }
        }
        stage('Merge') {
            when {
                expression { "${env.CHANGE_TARGET}" != "${env.CHANGE_TARGET}" }
            }
            steps {
                script{
                    echo "Merging branch ${env.CHANGE_TARGET} into ${env.CHANGE_TARGET}"
                    sh "git checkout ${env.CHANGE_TARGET}"
                    sh "git merge origin/${env.CHANGE_TARGET}"
                }
            }
        }
        stage('Build JAR') {
            steps {
                script {
                    sh "./gradlew build"
                }
            }
        }
        stage('Docker build and push to nexus') {
            environment{
                PKR_VAR_environment = "development"
            }
            steps {
                sshagent(credentials: ['8a93fd64-3029-4a20-b830-809bb70593ee']) {
                    withCredentials([
                        usernamePassword(credentialsId: 'e29f59a5-3fe6-4235-8d9a-ccbea6113412', usernameVariable: 'NEXUS_USERNAME', passwordVariable: 'NEXUS_PASSWORD')]){
						echo "make docker/login"
						echo "make docker/build"
						echo "make docker/push"
                        sh "date
                    }
                }
            }
        }
    }
    post {
        always {
            script { cleanWs() }
        }
        success {
            script {
                bitbucketStatusNotify(
                    buildState: 'SUCCESSFUL',
                    buildName: "${env.JOB_NAME}",
                    buildKey: "${env.JOB_NAME}",
                    repoSlug: "${env.REPO_SLUG}",
                    commitId: "${env.GIT_COMMIT}"
                )
            }
        }
        unsuccessful {
            script {
                bitbucketStatusNotify(
                    buildState: 'FAILED',
                    buildName: "${env.JOB_NAME}",
                    buildKey: "${env.JOB_NAME}",
                    repoSlug: "${env.REPO_SLUG}",
                    commitId: "${env.GIT_COMMIT}"
                )
            }
        }
    }
}
