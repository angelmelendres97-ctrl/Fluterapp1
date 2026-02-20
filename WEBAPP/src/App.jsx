import { useState } from 'react';
import { useHashRoute } from './hooks/useHashRoute';
import { ROUTES } from './utils/constants';
import { LandingPage } from './pages/landing/LandingPage';
import { LoginPage } from './pages/auth/LoginPage';
import { AdminShell } from './pages/admin/AdminShell';
import { useAuth } from './hooks/useAuth';

function App() {
  const { path, navigate } = useHashRoute();
  const auth = useAuth();
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const handleLogin = async ({ email, password }) => {
    try {
      setLoading(true);
      setError('');
      await auth.login(email, password);
      navigate(ROUTES.adminDashboard);
    } catch (loginError) {
      setError(loginError.message);
    } finally {
      setLoading(false);
    }
  };

  if (!auth.isAuthenticated && path.startsWith('/admin')) {
    navigate(ROUTES.login);
    return null;
  }

  if (path === ROUTES.landing) {
    return <LandingPage navigateToLogin={() => navigate(ROUTES.login)} />;
  }

  if (path === ROUTES.login) {
    return (
      <LoginPage
        onBack={() => navigate(ROUTES.landing)}
        onSubmit={handleLogin}
        loading={loading}
        error={error}
      />
    );
  }

  if (path.startsWith('/admin')) {
    return <AdminShell path={path} navigate={navigate} auth={auth} />;
  }

  navigate(ROUTES.landing);
  return null;
}

export default App;
