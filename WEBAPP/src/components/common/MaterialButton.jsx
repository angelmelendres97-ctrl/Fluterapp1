export function MaterialButton({ children, variant = 'primary', className = '', ...props }) {
  const variantClass =
    variant === 'secondary'
      ? 'bg-white text-amed-700 border border-amed-100'
      : 'bg-amed-500 text-white shadow-md shadow-amed-100';

  return (
    <button className={`material-btn ${variantClass} ${className}`} {...props}>
      {children}
    </button>
  );
}
