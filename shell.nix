{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    # Ici on prend Python 3 et on lui injecte DIRECTEMENT Tkinter
    (pkgs.python3.withPackages (ps: with ps; [
      tkinter
      pip
      virtualenv
    ]))
    # On ajoute les libs système pour que Tkinter puisse s'afficher à l'écran
    pkgs.xorg.libX11
  ];

  shellHook = ''
    # Si le venv existe pas, on le crée
    if [ ! -d ".venv" ]; then
      python -m venv .venv
    fi
    # On active le venv
    source .venv/bin/activate
    echo "=== Environnement NixOS + Tkinter + Mailtrap Prêt ! ==="
  '';
}
