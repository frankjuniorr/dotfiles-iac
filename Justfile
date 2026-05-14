set shell := ["bash", "-c"]

ansible_cmd := "ansible-playbook main.yaml -i hosts.yaml"

# Setup inicial: instala hooks e dependências Ansible
init: install-hooks
    ansible-galaxy collection install -r requirements.yaml

# Instala git hooks
install-hooks:
    @echo "Installing git pre-commit hook..."
    @cp -f scripts/pre-commit.sh .git/hooks/pre-commit
    @chmod +x .git/hooks/pre-commit
    @echo "Hook installed successfully."

############################################################################
# VM LIFECYCLE
############################################################################

create OS:
    @{{ansible_cmd}} --extra-vars "os_type_list=['{{OS}}']" --tags "create"

post-install OS:
    @{{ansible_cmd}} --extra-vars "os_type_list=['{{OS}}']" --tags "post-install"

start OS:
    @{{ansible_cmd}} --extra-vars "os_type_list=['{{OS}}']" --tags "start"

stop OS:
    @{{ansible_cmd}} --extra-vars "os_type_list=['{{OS}}']" --tags "stop"

destroy OS:
    @{{ansible_cmd}} --extra-vars "os_type_list=['{{OS}}']" --tags "destroy"

############################################################################
# UTILS
############################################################################
# Liga/Desliga o plugin de saída estética (beautiful_output) para visualização ou debug
plugin state:
    @if [ "{{state}}" == "on" ]; then \
        sed -i '/^# *stdout_callback = beautiful_output/s/^# *//' ansible.cfg; \
        echo "Plugin 'beautiful_output' ATIVADO."; \
    elif [ "{{state}}" == "off" ]; then \
        sed -i '/^stdout_callback = beautiful_output/s/^/# /' ansible.cfg; \
        echo "Plugin 'beautiful_output' DESATIVADO."; \
    else \
        echo "Use: just plugin on ou just plugin off"; \
    fi
