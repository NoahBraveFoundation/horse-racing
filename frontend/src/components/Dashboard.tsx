import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { graphql, useLazyLoadQuery, useMutation } from 'react-relay';
import Header from './Header';
import Footer from './Footer';
import { useLogout, getCurrentUser } from '../utils/auth'
import DashboardBoard from './horse-board/DashboardBoard';
import ErrorBoundary from './common/ErrorBoundary';
import ErrorFallback from './common/ErrorFallback';
import type { DashboardAdminQuery } from '../__generated__/DashboardAdminQuery.graphql';
import type { DashboardMarkPaidMutation } from '../__generated__/DashboardMarkPaidMutation.graphql';
import type { DashboardSetAdminMutation } from '../__generated__/DashboardSetAdminMutation.graphql';
import type { DashboardReleaseHorseMutation } from '../__generated__/DashboardReleaseHorseMutation.graphql';
import type { DashboardReleaseCartMutation } from '../__generated__/DashboardReleaseCartMutation.graphql';
import type { DashboardSetSeatAssignmentMutation } from '../__generated__/DashboardSetSeatAssignmentMutation.graphql';

const adminQuery = graphql`
  query DashboardAdminQuery {
    pendingPayments { id totalCents user { id firstName lastName email } }
    users { id email firstName lastName isAdmin }
    adminStats { ticketCount sponsorCount giftBasketCount }
    allHorses { id horseName state round { name } lane { number } owner { firstName lastName } }
    allTickets { id attendeeFirst attendeeLast seatingPreference seatAssignment owner { firstName lastName } }
    abandonedCarts { id orderNumber user { id firstName lastName email } }
    sponsorInterests { id companyName companyLogoBase64 }
    giftBasketInterests { id description user { firstName lastName } }
  }
`;

const markPaidMutation = graphql`
  mutation DashboardMarkPaidMutation($paymentId: UUID!) {
    markPaymentReceived(paymentId: $paymentId) { id paymentReceived }
  }
`;

const setAdminMutation = graphql`
  mutation DashboardSetAdminMutation($userId: UUID!, $isAdmin: Boolean!) {
    setUserAdmin(userId: $userId, isAdmin: $isAdmin) { id isAdmin }
  }
`;

const releaseHorseMutation = graphql`
  mutation DashboardReleaseHorseMutation($horseId: UUID!) {
    releaseHorse(horseId: $horseId)
  }
`;

const releaseCartMutation = graphql`
  mutation DashboardReleaseCartMutation($cartId: UUID!) {
    releaseCart(cartId: $cartId) { id status }
  }
`;

const setSeatAssignmentMutation = graphql`
  mutation DashboardSetSeatAssignmentMutation($ticketId: UUID!, $seatAssignment: String) {
    setTicketSeatAssignment(ticketId: $ticketId, seatAssignment: $seatAssignment) { id seatAssignment }
  }
`;

const runCleanupMutation = graphql`
  mutation DashboardRunCleanupMutation {
    runAdminCleanup
  }
`;

interface LocalUser {
  id: string;
  email: string;
  firstName: string;
  lastName: string;
  isAdmin: boolean;
}

export const Dashboard: React.FC = () => {
  const navigate = useNavigate();
  const [user, setUser] = useState<LocalUser | null>(null);
  const [refreshKey, setRefreshKey] = useState(0);
  const { logout } = useLogout();

  useEffect(() => {
    const userData = getCurrentUser();

    if (!userData) {
      navigate('/login', { replace: true });
      return;
    }

    if (!userData.isAdmin) {
      navigate('/account', { replace: true });
      return;
    }
    setUser(userData);
  }, [navigate]);

  const data = useLazyLoadQuery<DashboardAdminQuery>(adminQuery, {}, { fetchKey: refreshKey, fetchPolicy: 'network-only' });

  const [commitMarkPaid] = useMutation<DashboardMarkPaidMutation>(markPaidMutation);
  const [commitSetAdmin] = useMutation<DashboardSetAdminMutation>(setAdminMutation);
  const [commitReleaseHorse] = useMutation<DashboardReleaseHorseMutation>(releaseHorseMutation);
  const [commitReleaseCart] = useMutation<DashboardReleaseCartMutation>(releaseCartMutation);
  const [commitRunCleanup] = useMutation(runCleanupMutation);
  const [commitSetSeatAssignment] = useMutation<DashboardSetSeatAssignmentMutation>(setSeatAssignmentMutation);

  const refresh = () => setRefreshKey(k => k + 1);

  const handleLogout = () => {
    logout('/login?redirectTo=/dashboard')
  }

  if (!user) return null;

  const onMarkPaid = (id: string) => {
    commitMarkPaid({ variables: { paymentId: id }, onCompleted: refresh });
  };

  const onToggleAdmin = (id: string, isAdmin: boolean) => {
    commitSetAdmin({ variables: { userId: id, isAdmin }, onCompleted: refresh });
  };

  const onReleaseHorse = (id: string) => {
    commitReleaseHorse({ variables: { horseId: id }, onCompleted: refresh });
  };

  const onReleaseCart = (id: string) => {
    commitReleaseCart({ variables: { cartId: id }, onCompleted: refresh });
  };

  const onSetSeatAssignment = (id: string, seat: string) => {
    commitSetSeatAssignment({ variables: { ticketId: id, seatAssignment: seat || null }, onCompleted: refresh });
  };

  const onRunCleanup = () => {
    commitRunCleanup({ variables: {}, onCompleted: refresh });
  };

  const onHoldHorses = data.allHorses.filter(h => h.state.toLowerCase() === 'on_hold');

  return (
    <div className="min-h-screen bg-gradient-to-b from-noahbrave-50 to-white font-body text-gray-800">
      <Header />
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 space-y-10">
        <div className="text-center">
          <h1 className="font-heading text-4xl md:text-5xl text-gray-900 mb-2">Admin Dashboard</h1>
          <p className="text-lg text-gray-700">Welcome back, {user.firstName}!</p>
        </div>

        {/* Reports */}
        <section className="bg-white rounded-xl p-6 shadow">
          <h2 className="text-xl font-semibold mb-4">Reports</h2>
          <div className="grid md:grid-cols-3 gap-4 text-center">
            <div>
              <div className="text-3xl font-bold">{data.adminStats.ticketCount}</div>
              <div className="text-sm text-gray-600">Tickets Sold</div>
            </div>
            <div>
              <div className="text-3xl font-bold">{data.adminStats.giftBasketCount}</div>
              <div className="text-sm text-gray-600">Raffle Signups</div>
            </div>
            <div>
              <div className="text-3xl font-bold">{data.adminStats.sponsorCount}</div>
              <div className="text-sm text-gray-600">Sponsors</div>
            </div>
          </div>
          {data.sponsorInterests.length > 0 && (
            <div className="mt-6">
              <h3 className="font-semibold mb-2">Sponsors</h3>
              <div className="flex flex-wrap gap-4">
                {data.sponsorInterests.map(s => (
                  <div key={s.id} className="text-center">
                    {s.companyLogoBase64 && (
                      <img src={s.companyLogoBase64} alt={s.companyName} className="h-12 mx-auto mb-1" />
                    )}
                    <div className="text-sm">{s.companyName}</div>
                  </div>
                ))}
              </div>
            </div>
          )}
          {data.giftBasketInterests.length > 0 && (
            <div className="mt-6">
              <h3 className="font-semibold mb-2">Raffle Basket Signups</h3>
              <ul className="list-disc list-inside text-sm text-gray-700">
                {data.giftBasketInterests.map(g => (
                  <li key={g.id}>{g.description} - {g.user.firstName}</li>
                ))}
              </ul>
            </div>
          )}
        </section>

        {/* Payment management */}
        <section className="bg-white rounded-xl p-6 shadow">
          <h2 className="text-xl font-semibold mb-4">Payments</h2>
          <table className="w-full text-sm">
            <thead>
              <tr className="text-left border-b"><th className="py-2">User</th><th>Total</th><th></th></tr>
            </thead>
            <tbody>
              {data.pendingPayments.map(p => (
                <tr key={p.id} className="border-b">
                  <td className="py-2">{p.user.firstName} {p.user.lastName} ({p.user.email})</td>
                  <td>${(p.totalCents/100).toFixed(2)}</td>
                  <td><button className="text-blue-600" onClick={() => onMarkPaid(p.id)}>Mark Paid</button></td>
                </tr>
              ))}
              {data.pendingPayments.length === 0 && (
                <tr><td colSpan={3} className="py-2 text-center text-gray-500">No pending payments</td></tr>
              )}
            </tbody>
          </table>
        </section>

        {/* Tickets */}
        <section className="bg-white rounded-xl p-6 shadow">
          <h2 className="text-xl font-semibold mb-4">Tickets</h2>
          <table className="w-full text-sm">
            <thead>
              <tr className="text-left border-b"><th className="py-2">Attendee</th><th>Owner</th><th>Seating Preference</th><th>Seat Assignment</th></tr>
            </thead>
            <tbody>
              {data.allTickets.map(t => (
                <tr key={t.id} className="border-b">
                  <td className="py-2">{t.attendeeFirst} {t.attendeeLast}</td>
                  <td>{t.owner.firstName} {t.owner.lastName}</td>
                  <td>{t.seatingPreference || '-'}</td>
                  <td>
                    <input
                      type="text"
                      defaultValue={t.seatAssignment ?? ''}
                      onBlur={e => onSetSeatAssignment(t.id, e.target.value)}
                      className="border rounded px-1 py-0.5"
                    />
                  </td>
                </tr>
              ))}
              {data.allTickets.length === 0 && (
                <tr><td colSpan={4} className="py-2 text-center text-gray-500">No tickets</td></tr>
              )}
            </tbody>
          </table>
        </section>

        {/* User management */}
        <section className="bg-white rounded-xl p-6 shadow">
          <h2 className="text-xl font-semibold mb-4">Users</h2>
          <table className="w-full text-sm">
            <thead>
              <tr className="text-left border-b"><th className="py-2">Name</th><th>Email</th><th>Admin</th></tr>
            </thead>
            <tbody>
              {data.users.map(u => (
                <tr key={u.id} className="border-b">
                  <td className="py-2">{u.firstName} {u.lastName}</td>
                  <td>{u.email}</td>
                  <td>
                    <input type="checkbox" checked={u.isAdmin} onChange={e => onToggleAdmin(u.id, e.target.checked)} />
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </section>

        {/* Horse board overview */}
        <section className="bg-white rounded-xl p-6 shadow">
          <h2 className="text-xl font-semibold mb-4">Horse Board</h2>
          <table className="w-full text-sm">
            <thead>
              <tr className="text-left border-b"><th className="py-2">Horse</th><th>Owner</th><th>Round</th><th>Lane</th><th>State</th></tr>
            </thead>
            <tbody>
              {data.allHorses.map(h => (
                <tr key={h.id} className="border-b">
                  <td className="py-2">{h.horseName}</td>
                  <td>{h.owner.firstName} {h.owner.lastName}</td>
                  <td>{h.round.name}</td>
                  <td>{h.lane.number}</td>
                  <td className="capitalize">{h.state.replace('_', ' ')}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </section>

        {/* Visual Horse Board */}
        <section className="bg-white rounded-xl p-6 shadow">
          <h2 className="text-xl font-semibold mb-4">Visual Horse Board</h2>
          <DashboardBoard />
        </section>

        {/* Cleanup */}
        <section className="bg-white rounded-xl p-6 shadow">
          <h2 className="text-xl font-semibold mb-4">Cleanup</h2>
          <div className="mb-4">
            <h3 className="font-semibold mb-2">On-hold Horses</h3>
            <table className="w-full text-sm">
              <thead><tr className="text-left border-b"><th className="py-2">Horse</th><th>Round</th><th>Lane</th><th></th></tr></thead>
              <tbody>
                {onHoldHorses.map(h => (
                  <tr key={h.id} className="border-b">
                    <td className="py-2">{h.horseName}</td>
                    <td>{h.round.name}</td>
                    <td>{h.lane.number}</td>
                    <td><button className="text-red-600" onClick={() => onReleaseHorse(h.id)}>Release</button></td>
                  </tr>
                ))}
                {onHoldHorses.length === 0 && (
                  <tr><td colSpan={4} className="py-2 text-center text-gray-500">No on-hold horses</td></tr>
                )}
              </tbody>
            </table>
          </div>
          <div>
            <h3 className="font-semibold mb-2">Abandoned Carts</h3>
            <table className="w-full text-sm">
              <thead><tr className="text-left border-b"><th className="py-2">Order</th><th>User</th><th></th></tr></thead>
              <tbody>
                {data.abandonedCarts.map(c => (
                  <tr key={c.id} className="border-b">
                    <td className="py-2">{c.orderNumber}</td>
                    <td>{c.user.firstName} {c.user.lastName}</td>
                    <td><button className="text-red-600" onClick={() => onReleaseCart(c.id)}>Release</button></td>
                  </tr>
                ))}
                {data.abandonedCarts.length === 0 && (
                  <tr><td colSpan={3} className="py-2 text-center text-gray-500">No abandoned carts</td></tr>
                )}
              </tbody>
            </table>
          </div>
        </section>

        <div className="flex items-center justify-center gap-3">
          <button onClick={onRunCleanup} className="inline-flex items-center px-6 py-3 border border-red-300 rounded-lg text-red-700 hover:bg-red-50">Run Cleanup</button>
          <button onClick={handleLogout} className="inline-flex items-center px-6 py-3 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50">Logout</button>
        </div>
      </div>
      <Footer />
    </div>
  );
};

const DashboardWithErrorBoundary: React.FC = () => (
  <ErrorBoundary fallback={
    <ErrorFallback 
      title="Dashboard Error"
      message="Unable to load the admin dashboard. You may not have permission to access this page, or there was an error loading the data."
      logoutRedirectTo="/login?redirectTo=/dashboard"
    />
  }>
    <Dashboard />
  </ErrorBoundary>
);

export default DashboardWithErrorBoundary;
