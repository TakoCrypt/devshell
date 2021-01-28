{ pkgs, devshell }:
{
  # Basic devshell usage
  commands-1 =
    let
      shell = devshell.mkShell {
        devshell.name = "commands-1";
        commands = [
          {
            name = "bash-script";
            category = "hello";
            help = "Prints hello-bash";
            command = ''
              echo "hello-bash"
            '';
          }
          {
            name = "python-script";
            category = "hello";
            help = "Prints hello-python";
            command = ''
              #!/usr/bin/env python3
              print("hello-python")
            '';
          }
          {
            package = "git";
          }
        ];
      };
    in
    pkgs.runCommand "devshell-1" { } ''
      # Load the devshell
      source ${shell}

      menu

      # Checks that all the commands are available
      type -p bash-script
      type -p python-script
      type -p git

      [[ $(bash-script) == hello-bash ]]

      # Check that the shebang is correct. We can't execute it inside of the
      # sandbox because /usr/bin/env doesn't exist.
      #
      # Ideally it would be rewritten with patchShebang.
      [[ $(head -n1 "$(type -p python-script)") == "#!/usr/bin/env python3" ]]

      touch $out
    '';
}
