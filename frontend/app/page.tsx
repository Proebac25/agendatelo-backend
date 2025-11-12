import Link from 'next/link';

export default function Home() {
  return (
    <main style={{ padding: '40px', textAlign: 'center' }}>
      <h1>Bienvenido a Agendatelo</h1>
      <p>
        <Link href="/users" style={{ color: 'blue', textDecoration: 'underline' }}>
          Ir a la lista de usuarios
        </Link>
      </p>
    </main>
  );
}