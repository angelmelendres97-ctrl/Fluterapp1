import { PublicHeader } from '../../components/layout/PublicHeader';
import { HeroSection } from '../../components/landing/HeroSection';

export function LandingPage({ navigateToLogin }) {
  return (
    <div className="min-h-screen bg-gradient-to-b from-white to-amed-50">
      <PublicHeader onLoginClick={navigateToLogin} />
      <HeroSection onLoginClick={navigateToLogin} />
    </div>
  );
}
