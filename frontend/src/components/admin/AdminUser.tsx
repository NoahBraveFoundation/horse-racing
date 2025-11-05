import React, { useState } from 'react';
import { useParams, Link } from 'react-router-dom';
import { graphql, useLazyLoadQuery, useMutation } from 'react-relay';
import Header from '../Header';
import Footer from '../Footer';
import type { AdminUserQuery } from '../../__generated__/AdminUserQuery.graphql';
import type { AdminUserRemoveTicketMutation } from '../../__generated__/AdminUserRemoveTicketMutation.graphql';
import type { AdminUserRemoveHorseMutation } from '../../__generated__/AdminUserRemoveHorseMutation.graphql';

const adminUserQuery = graphql`
  query AdminUserQuery($userId: UUID!) {
    user(userId: $userId) {
      id
      firstName
      lastName
      email
      carts {
        id
        status
        orderNumber
        tickets { id attendeeFirst attendeeLast }
        horses { id horseName ownershipLabel }
        cost { ticketsCents horseCents sponsorCents totalCents }
      }
      payments {
        id
        totalCents
        paymentReceived
        paymentReceivedAt
        createdAt
        cart { id orderNumber }
      }
    }
  }
`;

const removeTicketMutation = graphql`
  mutation AdminUserRemoveTicketMutation($ticketId: UUID!) {
    adminRemoveTicket(ticketId: $ticketId)
  }
`;

const removeHorseMutation = graphql`
  mutation AdminUserRemoveHorseMutation($horseId: UUID!) {
    adminRemoveHorse(horseId: $horseId)
  }
`;

const AdminUser: React.FC = () => {
  const { userId } = useParams();
  const [refreshKey, setRefreshKey] = useState(0);
  const data = useLazyLoadQuery<AdminUserQuery>(adminUserQuery, { userId: userId! }, { fetchKey: refreshKey, fetchPolicy: 'network-only' });
  const formatDateTime = (value: string | null | undefined) => {
    if (!value) {
      return '—';
    }
    const timestamp = Date.parse(value);
    if (Number.isNaN(timestamp)) {
      return value;
    }
    return new Date(timestamp).toLocaleString();
  };
  const [commitRemoveTicket] = useMutation<AdminUserRemoveTicketMutation>(removeTicketMutation);
  const [commitRemoveHorse] = useMutation<AdminUserRemoveHorseMutation>(removeHorseMutation);

  const refresh = () => setRefreshKey(k => k + 1);

  const onRemoveTicket = (id: string) => {
    if (window.confirm('Remove this ticket?')) {
      commitRemoveTicket({ variables: { ticketId: id }, onCompleted: refresh });
    }
  };

  const onRemoveHorse = (id: string) => {
    if (window.confirm('Remove this horse?')) {
      commitRemoveHorse({ variables: { horseId: id }, onCompleted: refresh });
    }
  };

  if (!data.user) {
    return <div className="p-6">User not found</div>;
  }

  const u = data.user;

  return (
    <div className="min-h-screen bg-gradient-to-b from-noahbrave-50 to-white font-body text-gray-800">
      <Header />
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-10 space-y-6">
        <Link to="/dashboard" className="text-blue-600">&larr; Back to Dashboard</Link>
        <div>
          <h1 className="font-heading text-3xl text-gray-900">{u.firstName} {u.lastName}</h1>
          <p className="text-gray-700">{u.email}</p>
        </div>
        <section className="bg-white rounded-xl p-6 shadow">
          <h2 className="text-xl font-semibold mb-4">Carts</h2>
          {u.carts.length === 0 && <div className="text-sm text-gray-500">No carts</div>}
          {u.carts.map(c => (
            <div key={c.id} className="mb-6 border-b pb-4 last:border-b-0 last:pb-0">
              <div className="font-medium mb-2">Order {c.orderNumber} - {c.status}</div>
              <div className="space-y-2">
                {c.tickets.map(t => (
                  <div key={t.id} className="flex justify-between items-center">
                    <div>Ticket: {t.attendeeFirst} {t.attendeeLast}</div>
                    <button className="text-red-600" onClick={() => onRemoveTicket(t.id)}>Remove</button>
                  </div>
                ))}
                {c.horses.map(h => (
                  <div key={h.id} className="flex justify-between items-center">
                    <div>Horse: {h.horseName} {h.ownershipLabel && `(${h.ownershipLabel})`}</div>
                    <button className="text-red-600" onClick={() => onRemoveHorse(h.id)}>Remove</button>
                  </div>
                ))}
                <div className="text-sm text-gray-700 pt-2">
                  <div>Tickets: ${(c.cost.ticketsCents / 100).toFixed(2)}</div>
                  <div>Horses: ${(c.cost.horseCents / 100).toFixed(2)}</div>
                  <div>Sponsors: ${(c.cost.sponsorCents / 100).toFixed(2)}</div>
                  <div className="font-semibold">Total: ${(c.cost.totalCents / 100).toFixed(2)}</div>
                </div>
              </div>
            </div>
          ))}
        </section>
        <section className="bg-white rounded-xl p-6 shadow">
          <h2 className="text-xl font-semibold mb-4">Payments</h2>
          {u.payments.length === 0 ? (
            <div className="text-sm text-gray-500">No payments</div>
          ) : (
            <ul className="space-y-3">
              {u.payments.map(p => (
                <li key={p.id} className="border rounded-lg px-3 py-2">
                  <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-2">
                    <div>
                      <div className="font-medium">Order {p.cart?.orderNumber ?? '—'}</div>
                      <div className="text-sm text-gray-600">
                        {p.paymentReceived ? 'Paid' : 'Pending'} • ${(p.totalCents / 100).toFixed(2)}
                      </div>
                    </div>
                    <div className="text-sm text-gray-600">
                      {p.paymentReceived
                        ? `Marked paid ${formatDateTime(p.paymentReceivedAt ?? p.createdAt)}`
                        : `Submitted ${formatDateTime(p.createdAt)}`}
                    </div>
                  </div>
                </li>
              ))}
            </ul>
          )}
        </section>
      </div>
      <Footer />
    </div>
  );
};

export default AdminUser;
