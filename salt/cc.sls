#!stateconf
sls_params:
  stateconf.set:
    - name1: valuASDASDe1
    - name2: value2
    - name3:
      - value1
      - value2
      - value3
    - require_in:
      - cmd: output

# --- end of state config ---

output:
  cmd.run:
    - name: echo {{ "{{ sls_params.name1 }}" }}

