#!/bin/sh
set -eu

# Entrypoint propio (RF3, RF4 / D3, D4).
# Envoltorio: hace su trabajo y delega en el entrypoint oficial de nginx.

echo "[entrypoint.01-nginx] inicio"

# RF4.2: falla con mensaje claro si APP_MESSAGE no está definida.
: "${APP_MESSAGE:?[entrypoint.01-nginx] APP_MESSAGE no está definida}"

# RF4.3: genera el index.html incluyendo el valor de APP_MESSAGE.
cat > /usr/share/nginx/html/index.html <<EOF
<!DOCTYPE html>
<html lang="es">
  <head>
    <meta charset="utf-8">
    <title>nginx SDD</title>
  </head>
  <body>
    <h1>${APP_MESSAGE}</h1>
  </body>
</html>
EOF

echo "[entrypoint.01-nginx] index.html generado desde APP_MESSAGE"

# P7: conserva el comportamiento oficial de nginx y el manejo de señales.
exec /docker-entrypoint.sh "$@"
