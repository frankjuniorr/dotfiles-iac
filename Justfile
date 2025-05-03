# Comando principal com dois parâmetros: TAG e OS
playbook TAG OS:
    @echo "Executando playbook com tag='{{TAG}}' e os_type_list='[\'{{OS}}\']'"
    ansible-playbook main.yaml -i hosts.yaml --extra-vars "os_type_list=['{{OS}}']" --tags "{{TAG}}"
