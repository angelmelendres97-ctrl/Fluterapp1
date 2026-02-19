import { useEffect, useMemo, useState } from 'react';
import { ROUTES } from '../utils/constants';

const normalizePath = (value) => {
  if (!value || value === '#') return ROUTES.landing;
  const withoutHash = value.startsWith('#') ? value.slice(1) : value;
  return withoutHash.startsWith('/') ? withoutHash : `/${withoutHash}`;
};

export function useHashRoute() {
  const [path, setPath] = useState(normalizePath(window.location.hash));

  useEffect(() => {
    const onChange = () => setPath(normalizePath(window.location.hash));
    window.addEventListener('hashchange', onChange);
    return () => window.removeEventListener('hashchange', onChange);
  }, []);

  const navigate = (nextPath) => {
    window.location.hash = nextPath;
  };

  return useMemo(() => ({ path, navigate }), [path]);
}
