{ writeShellApplication, wol }:

let samaritan = {
      ip = "10.40.1.52";
      mac = "a8:a1:59:3a:9e:5a";
    };

in writeShellApplication {
  name = "resurrect";
  runtimeInputs = [ wol ];
  text = ''
  if [ "$1" == "samaritan" ]; then
      wol -i ${samaritan.ip} ${samaritan.mac}
  else
      echo "Does not recognize the machine with name $1"
  fi
  '';
}
