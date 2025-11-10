import React, { useEffect, useMemo, useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { graphql, useLazyLoadQuery, useMutation } from 'react-relay';
import Header from './Header';
import Footer from './Footer';
import { useLogout, getCurrentUser } from '../utils/auth'
import DashboardBoard from './horse-board/DashboardBoard';
import ErrorBoundary from './common/ErrorBoundary';
import ErrorFallback from './common/ErrorFallback';
import LoadingIndicator from './common/LoadingIndicator';
import type { DashboardAdminQuery } from '../__generated__/DashboardAdminQuery.graphql';
import type { DashboardSetPaymentReceivedMutation } from '../__generated__/DashboardSetPaymentReceivedMutation.graphql';
import type { DashboardSetAdminMutation } from '../__generated__/DashboardSetAdminMutation.graphql';
import type { DashboardReleaseHorseMutation } from '../__generated__/DashboardReleaseHorseMutation.graphql';
import type { DashboardReleaseCartMutation } from '../__generated__/DashboardReleaseCartMutation.graphql';
import type { DashboardSetSeatAssignmentMutation } from '../__generated__/DashboardSetSeatAssignmentMutation.graphql';
import type { DashboardResetDatabaseMutation } from '../__generated__/DashboardResetDatabaseMutation.graphql';
import type { DashboardRemoveSponsorInterestMutation } from '../__generated__/DashboardRemoveSponsorInterestMutation.graphql';

const adminQuery = graphql`
  query DashboardAdminQuery {
    payments {
      id
      totalCents
      paymentReceived
      paymentReceivedAt
      createdAt
      cart { id orderNumber }
      user { id firstName lastName email }
    }
    users { id email firstName lastName isAdmin }
    adminStats { ticketCount sponsorCount giftBasketCount }
    allHorses { id horseName state round { name } lane { number } owner { firstName lastName } }
    allTickets { id attendeeFirst attendeeLast seatingPreference seatAssignment state owner { firstName lastName } }
    abandonedCarts { id orderNumber user { id firstName lastName email } }
    sponsorInterests { id companyName companyLogoBase64 costCents user { id firstName lastName email } }
    giftBasketInterests { id description user { firstName lastName } }
  }
`;

const setPaymentReceivedMutation = graphql`
  mutation DashboardSetPaymentReceivedMutation($paymentId: UUID!, $received: Boolean!) {
    setPaymentReceived(paymentId: $paymentId, received: $received) { id paymentReceived }
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

const resetDatabaseMutation = graphql`
  mutation DashboardResetDatabaseMutation {
    resetDatabase
  }
`;

const removeSponsorInterestMutation = graphql`
  mutation DashboardRemoveSponsorInterestMutation($sponsorInterestId: UUID!) {
    adminRemoveSponsorInterest(sponsorInterestId: $sponsorInterestId)
  }
`;

const TICKETS_PER_PAGE = 12;

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
  const [authChecked, setAuthChecked] = useState(false);
  const [isDataLoading, setIsDataLoading] = useState(true);
  const [ticketStatusFilter, setTicketStatusFilter] = useState<'all' | 'active' | 'on_hold'>('all');
  const [ticketPage, setTicketPage] = useState(1);
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
    setAuthChecked(true);
  }, [navigate]);

  const data = useLazyLoadQuery<DashboardAdminQuery>(adminQuery, {}, { fetchKey: refreshKey, fetchPolicy: 'network-only' });

  useEffect(() => {
    setIsDataLoading(false);
  }, [data]);

  const APPLE_REFERENCE_EPOCH_SECONDS = 978_307_200;

  const normalizeTicketStatus = (value: string | null | undefined) => {
    const normalized = (value ?? '').trim().toLowerCase();
    return normalized || 'active';
  };

  const normalizeNumericDate = (num: number): number | undefined => {
    if (!Number.isFinite(num)) {
      return undefined;
    }

    if (num > 1e12) {
      // Already in milliseconds since Unix epoch.
      return num;
    }

    if (num > 1e9) {
      // Seconds since Unix epoch.
      return num * 1000;
    }

    // Seconds since Apple's reference date (Jan 1, 2001).
    return (num + APPLE_REFERENCE_EPOCH_SECONDS) * 1000;
  };

  const parseDate = (value: string | number | null | undefined): number | undefined => {
    if (value === null || value === undefined) {
      return undefined;
    }

    if (typeof value === 'number') {
      return normalizeNumericDate(value);
    }

    const trimmed = value.trim();
    if (!trimmed) {
      return undefined;
    }

    const parsed = Date.parse(trimmed);
    if (!Number.isNaN(parsed)) {
      return parsed;
    }

    const asNumber = Number(trimmed);
    if (!Number.isNaN(asNumber)) {
      return normalizeNumericDate(asNumber);
    }

    return undefined;
  };

  const formatDateTime = (value: string | number | null | undefined): string => {
    const timestamp = parseDate(value);
    if (timestamp === undefined) {
      if (value === null || value === undefined || value === '') {
        return '—';
      }
      return String(value);
    }
    return new Date(timestamp).toLocaleString();
  };

  const ticketsWithStatus = useMemo(
    () =>
      data.allTickets.map(ticket => {
        const status = normalizeTicketStatus(ticket.state);
        return {
          ticket,
          status,
          isOnHold: status === 'on_hold',
        };
      }),
    [data.allTickets],
  );

  const filteredTickets = useMemo(() => {
    if (ticketStatusFilter === 'all') {
      return ticketsWithStatus;
    }
    if (ticketStatusFilter === 'on_hold') {
      return ticketsWithStatus.filter(t => t.isOnHold);
    }
    return ticketsWithStatus.filter(t => !t.isOnHold);
  }, [ticketStatusFilter, ticketsWithStatus]);

  useEffect(() => {
    setTicketPage(1);
  }, [ticketStatusFilter]);

  useEffect(() => {
    const totalPages = Math.max(1, Math.ceil(filteredTickets.length / TICKETS_PER_PAGE));
    setTicketPage(prev => Math.min(prev, totalPages));
  }, [filteredTickets.length]);

  const totalTicketPages = Math.max(1, Math.ceil(filteredTickets.length / TICKETS_PER_PAGE));
  const currentTicketPage = Math.min(ticketPage, totalTicketPages);
  const paginatedTickets = filteredTickets.slice(
    (currentTicketPage - 1) * TICKETS_PER_PAGE,
    currentTicketPage * TICKETS_PER_PAGE,
  );
  const firstTicketIndex = filteredTickets.length === 0 ? 0 : (currentTicketPage - 1) * TICKETS_PER_PAGE + 1;
  const lastTicketIndex = Math.min(filteredTickets.length, currentTicketPage * TICKETS_PER_PAGE);

  const formatStatusLabel = (status: string) => {
    const normalized = status.replace(/_/g, ' ').trim();
    return normalized || 'active';
  };

  const timestampOrZero = (value: number | undefined) => value ?? 0;

  const pendingPayments = data.payments
    .filter(p => !p.paymentReceived)
    .sort((a, b) => timestampOrZero(parseDate(b.createdAt)) - timestampOrZero(parseDate(a.createdAt)));

  const paidPayments = data.payments
    .filter(p => p.paymentReceived)
    .sort((a, b) => {
      const bTime = parseDate(b.paymentReceivedAt) ?? parseDate(b.createdAt);
      const aTime = parseDate(a.paymentReceivedAt) ?? parseDate(a.createdAt);
      return timestampOrZero(bTime) - timestampOrZero(aTime);
    });

  const [commitSetPaymentReceived] = useMutation<DashboardSetPaymentReceivedMutation>(setPaymentReceivedMutation);
  const [commitSetAdmin] = useMutation<DashboardSetAdminMutation>(setAdminMutation);
  const [commitReleaseHorse] = useMutation<DashboardReleaseHorseMutation>(releaseHorseMutation);
  const [commitReleaseCart] = useMutation<DashboardReleaseCartMutation>(releaseCartMutation);
  const [commitRunCleanup] = useMutation(runCleanupMutation);
  const [commitResetDatabase] = useMutation<DashboardResetDatabaseMutation>(resetDatabaseMutation);
  const [commitSetSeatAssignment] = useMutation<DashboardSetSeatAssignmentMutation>(setSeatAssignmentMutation);
  const [commitRemoveSponsorInterest] = useMutation<DashboardRemoveSponsorInterestMutation>(removeSponsorInterestMutation);

  const refresh = () => {
    setIsDataLoading(true);
    setRefreshKey(k => k + 1);
  };

  const handleLogout = () => {
    logout('/login?redirectTo=/dashboard');
  };

  const isLoadingState = !authChecked || isDataLoading || !user;

  if (isLoadingState) {
    return (
      <div className="min-h-screen bg-gradient-to-b from-noahbrave-50 to-white font-body text-gray-800">
        <Header />
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
          <LoadingIndicator label="Loading dashboard..." />
        </div>
        <Footer />
      </div>
    );
  }

  const onSetPaymentReceived = (id: string, received: boolean) => {
    if (window.confirm(`Set this payment as ${received ? 'received' : 'not received'}?`)) {
      commitSetPaymentReceived({ variables: { paymentId: id, received }, onCompleted: refresh });
    }
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

  const onRemoveSponsorInterest = (id: string) => {
    if (window.confirm('Remove this sponsor interest?')) {
      commitRemoveSponsorInterest({ variables: { sponsorInterestId: id }, onCompleted: refresh });
    }
  };

  const onRunCleanup = () => {
    commitRunCleanup({ variables: {}, onCompleted: refresh });
  };

  const onResetDatabase = () => {
    if (window.confirm('⚠️ WARNING: This will permanently delete ALL data in the database including users, horses, tickets, and payments. This action cannot be undone. Are you absolutely sure you want to proceed?')) {
      if (window.confirm('🚨 FINAL WARNING: This will completely wipe the database. Type "RESET" to confirm.')) {
        const confirmation = window.prompt('Type "RESET" to confirm database reset:');
        if (confirmation === 'RESET') {
          commitResetDatabase({ 
            variables: {}, 
            onCompleted: () => {
              alert('Database has been reset. You will need to log in again.');
              window.location.href = '/login';
            },
            onError: (error) => {
              alert('Error resetting database: ' + error.message);
            }
          });
        }
      }
    }
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
              <table className="w-full text-sm">
                <thead>
                  <tr className="text-left border-b">
                    <th className="py-2">Company</th>
                    <th>Contact</th>
                    <th>Amount</th>
                    <th></th>
                  </tr>
                </thead>
                <tbody>
                  {data.sponsorInterests.map(s => (
                    <tr key={s.id} className="border-b">
                      <td className="py-2">
                        <div className="flex items-center gap-3">
                          {s.companyLogoBase64 && (
                            <img src={s.companyLogoBase64} alt={s.companyName} className="h-10 w-10 object-contain" />
                          )}
                          <span>{s.companyName}</span>
                        </div>
                      </td>
                      <td>{s.user.firstName} {s.user.lastName} ({s.user.email})</td>
                      <td>${(s.costCents / 100).toFixed(2)}</td>
                      <td className="text-right">
                        <button className="text-red-600" onClick={() => onRemoveSponsorInterest(s.id)}>Remove</button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
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
          <div className="space-y-6">
            <div>
              <h3 className="font-semibold mb-2">Pending</h3>
              {pendingPayments.length === 0 ? (
                <div className="text-sm text-gray-500">No pending payments</div>
              ) : (
                <table className="w-full text-sm">
                  <thead>
                    <tr className="text-left border-b">
                      <th className="py-2">Order</th>
                      <th>User</th>
                      <th>Submitted</th>
                      <th>Total</th>
                      <th></th>
                    </tr>
                  </thead>
                  <tbody>
                    {pendingPayments.map(p => (
                      <tr key={p.id} className="border-b bg-yellow-50/60">
                        <td className="py-2 font-medium">{p.cart?.orderNumber ?? '—'}</td>
                        <td>{p.user.firstName} {p.user.lastName} ({p.user.email})</td>
                        <td>{formatDateTime(p.createdAt)}</td>
                        <td>${(p.totalCents / 100).toFixed(2)}</td>
                        <td className="text-right">
                          <button className="text-blue-600" onClick={() => onSetPaymentReceived(p.id, true)}>Mark Paid</button>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              )}
            </div>

            <div>
              <h3 className="font-semibold mb-2">History</h3>
              {paidPayments.length === 0 ? (
                <div className="text-sm text-gray-500">No recorded payments yet</div>
              ) : (
                <table className="w-full text-sm">
                  <thead>
                    <tr className="text-left border-b">
                      <th className="py-2">Order</th>
                      <th>User</th>
                      <th>Paid At</th>
                      <th>Total</th>
                      <th></th>
                    </tr>
                  </thead>
                  <tbody>
                    {paidPayments.map(p => (
                      <tr key={p.id} className="border-b">
                        <td className="py-2 font-medium">{p.cart?.orderNumber ?? '—'}</td>
                        <td>{p.user.firstName} {p.user.lastName} ({p.user.email})</td>
                        <td>{formatDateTime(p.paymentReceivedAt ?? p.createdAt)}</td>
                        <td>${(p.totalCents / 100).toFixed(2)}</td>
                        <td className="text-right">
                          <button className="text-blue-600" onClick={() => onSetPaymentReceived(p.id, false)}>Unmark Paid</button>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              )}
            </div>
          </div>
        </section>

        {/* Ticket management */}
        <section className="bg-white rounded-xl p-6 shadow">
          <div className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
            <div>
              <h2 className="text-xl font-semibold">Tickets</h2>
              <p className="text-sm text-gray-500">Manage attendees, seating, and holds in one place.</p>
            </div>
            <div className="flex items-center gap-2">
              <span className="text-sm font-medium text-gray-600">Status:</span>
              {(['all', 'active', 'on_hold'] as const).map(filter => (
                <button
                  key={filter}
                  type="button"
                  onClick={() => setTicketStatusFilter(filter)}
                  className={`rounded-full px-3 py-1 text-sm font-medium transition ${
                    ticketStatusFilter === filter
                      ? 'bg-noahbrave-500 text-white shadow-sm'
                      : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
                  }`}
                  aria-pressed={ticketStatusFilter === filter}
                >
                  {filter === 'all' ? 'All' : filter === 'active' ? 'Active' : 'On Hold'}
                </button>
              ))}
            </div>
          </div>

          {filteredTickets.length === 0 ? (
            <div className="mt-6 text-sm text-gray-500">No tickets match the selected filter.</div>
          ) : (
            <>
              <div className="mt-6 overflow-x-auto">
                <table className="w-full text-sm">
                  <thead>
                    <tr className="text-left border-b">
                      <th className="py-2">Attendee</th>
                      <th>Owner</th>
                      <th>Status</th>
                      <th>Seating Preference</th>
                      <th>Seat Assignment</th>
                    </tr>
                  </thead>
                  <tbody>
                    {paginatedTickets.map(({ ticket, status, isOnHold }) => (
                      <tr key={ticket.id} className={`border-b ${isOnHold ? 'bg-yellow-50/60' : ''}`}>
                        <td className="py-2">{ticket.attendeeFirst} {ticket.attendeeLast}</td>
                        <td>{ticket.owner.firstName} {ticket.owner.lastName}</td>
                        <td className="capitalize">{formatStatusLabel(status)}</td>
                        <td>{ticket.seatingPreference || '—'}</td>
                        <td>
                          {isOnHold ? (
                            <span className="text-gray-500">{ticket.seatAssignment || '—'}</span>
                          ) : (
                            <input
                              type="text"
                              defaultValue={ticket.seatAssignment ?? ''}
                              onBlur={e => onSetSeatAssignment(ticket.id, e.target.value)}
                              className="w-32 rounded border px-2 py-1 text-sm focus:outline-none focus:ring-2 focus:ring-noahbrave-200"
                            />
                          )}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
              <div className="mt-4 flex flex-col gap-3 border-t pt-4 text-sm text-gray-600 md:flex-row md:items-center md:justify-between">
                <div>
                  Showing {firstTicketIndex}-{lastTicketIndex} of {filteredTickets.length} tickets
                </div>
                <div className="flex items-center gap-3">
                  <button
                    type="button"
                    onClick={() => setTicketPage(page => Math.max(1, page - 1))}
                    disabled={currentTicketPage === 1}
                    className="rounded border border-gray-300 px-3 py-1 transition hover:bg-gray-100 disabled:cursor-not-allowed disabled:opacity-50"
                  >
                    Previous
                  </button>
                  <span className="font-medium">Page {currentTicketPage} of {totalTicketPages}</span>
                  <button
                    type="button"
                    onClick={() => setTicketPage(page => Math.min(totalTicketPages, page + 1))}
                    disabled={currentTicketPage === totalTicketPages}
                    className="rounded border border-gray-300 px-3 py-1 transition hover:bg-gray-100 disabled:cursor-not-allowed disabled:opacity-50"
                  >
                    Next
                  </button>
                </div>
              </div>
            </>
          )}
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
                  <td className="py-2"><Link to={`/dashboard/user/${u.id}`} className="text-blue-600">{u.firstName} {u.lastName}</Link></td>
                  <td>{u.email}</td>
                  <td>
                    <input type="checkbox" checked={u.isAdmin} onChange={e => onToggleAdmin(u.id, e.target.checked)} />
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </section>

        {/* Horse Board */}
        <section className="bg-white rounded-xl p-6 shadow">
          <h2 className="text-xl font-semibold mb-4">Horse Board</h2>
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
          {user.email === 'austinjevans@me.com' && (
            <button onClick={onResetDatabase} className="inline-flex items-center px-6 py-3 border border-red-600 rounded-lg text-white bg-red-600 hover:bg-red-700 font-semibold">🚨 Reset Database</button>
          )}
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
