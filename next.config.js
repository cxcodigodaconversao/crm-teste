/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
  
  // Configuração de imagens (se usar Next Image)
  images: {
    domains: [
      'i.pravatar.cc', // Avatares de demo
      'lh3.googleusercontent.com', // Google avatars
    ],
  },

  // Variáveis de ambiente expostas ao browser
  env: {
    NEXT_PUBLIC_APP_NAME: 'CRM Conversão',
    NEXT_PUBLIC_APP_VERSION: '1.0.0',
  },

  // Headers de segurança
  async headers() {
    return [
      {
        source: '/(.*)',
        headers: [
          {
            key: 'X-Frame-Options',
            value: 'DENY',
          },
          {
            key: 'X-Content-Type-Options',
            value: 'nosniff',
          },
          {
            key: 'Referrer-Policy',
            value: 'strict-origin-when-cross-origin',
          },
        ],
      },
    ];
  },

  // Redirects (se necessário)
  async redirects() {
    return [
      {
        source: '/',
        destination: '/crm',
        permanent: false,
      },
    ];
  },

  // Webpack config (se precisar de customizações)
  webpack: (config, { isServer }) => {
    // Adicione customizações aqui se necessário
    return config;
  },
};

module.exports = nextConfig;
