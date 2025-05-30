#!/bin/bash

########################################################################################################################
# This script downloads the certificate information from $GITHUB_OIDC_HOST, extracts the certificate material, then uses
# the openssl command to calculate the thumbprint. It is meant to be called manually and the output used to populate
# the `thumbprint_list` variable in the terraform configuration for this module.
#
# This script will pull one of two thumbprints. There are two possible intermediary certificates for the Actions SSL
# certificate and either can be returned by the GitHub servers, requiring customers to trust both. This is a known
# behavior when the intermediary certificates are cross-signed by the CA. Therefore, run this script until both values
# are retrieved.
#
# For more, see https://github.blog/changelog/2023-06-27-github-actions-update-on-oidc-integration-with-aws/
########################################################################################################################
GITHUB_OIDC_HOST="token.actions.githubusercontent.com"
THUMBPRINT=$(echo \
	| openssl s_client -servername ${GITHUB_OIDC_HOST} -showcerts -connect ${GITHUB_OIDC_HOST}:443 2>&- \
	| tac \
	| sed -n '/-----END CERTIFICATE-----/,/-----BEGIN CERTIFICATE-----/p; /-----BEGIN CERTIFICATE-----/q' \
	| tac \
	| openssl x509 -fingerprint -noout | sed 's/://g' | awk -F= '{print tolower($2)}')

echo "$THUMBPRINT"
