FROM quay.io/keycloak/keycloak:26.0.7

# Copy theme JAR vào Keycloak providers
COPY dist_keycloak/keycloak-theme-for-kc-all-other-versions.jar /opt/keycloak/providers/keycloak-theme.jar

ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
