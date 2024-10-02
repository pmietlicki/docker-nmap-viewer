# Utiliser une image de base node pour la construction de l'application
FROM node:16-alpine AS builder

# Définir le répertoire de travail
WORKDIR /app

# Installer git dans l'image Alpine
RUN apk add --no-cache git

# Cloner le dépôt directement dans le répertoire de travail
RUN git clone https://github.com/psyray/nmap-viewer.git .

# Installer les dépendances
RUN npm install

# Construire l'application pour la production
RUN npm run build

# Étape finale : utiliser une image nginx non root pour servir les fichiers statiques
FROM nginxinc/nginx-unprivileged:stable-alpine

# Copier les fichiers construits de l'étape précédente dans le répertoire nginx
COPY --from=builder /app/build /usr/share/nginx/html

# Exposer le port 8080 (l'image nginx-unprivileged utilise ce port par défaut)
EXPOSE 8080

# Démarrer nginx lorsque le conteneur est lancé
CMD ["nginx", "-g", "daemon off;"]
