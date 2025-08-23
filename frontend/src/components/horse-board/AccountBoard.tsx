import React, { useEffect, useState } from 'react';
import { graphql, useLazyLoadQuery, commitMutation } from 'react-relay';
import RoundBoard from './RoundBoard';
import environment from '../../relay/environment';
import { renameHorseMutation } from '../../graphql/mutations/renameHorse';

const AccountBoardQuery = graphql`
  query AccountBoardQuery {
    me { id firstName lastName }
    rounds {
      id
      name
      startAt
      endAt
      lanes { id number horse { id horseName ownershipLabel owner { id firstName lastName } } }
      ...RoundBoardFragment
    }
  }
`;

const AccountBoard: React.FC = () => {
  const [refreshKey, setRefreshKey] = useState(0);
  useEffect(() => {
    const id = setInterval(() => setRefreshKey(k => k + 1), 5000);
    return () => clearInterval(id);
  }, []);

  const data: any = useLazyLoadQuery(AccountBoardQuery, {}, { fetchKey: refreshKey, fetchPolicy: 'network-only' });
  const me = data?.me;

  const [editing, setEditing] = useState<any>(null);
  const [horseName, setHorseName] = useState('');
  const [ownershipLabel, setOwnershipLabel] = useState('');
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const openEdit = (horse: any) => {
    setEditing(horse);
    setHorseName(horse.horseName);
    setOwnershipLabel(horse.ownershipLabel);
    setError(null);
  };

  const closeEdit = () => {
    setEditing(null);
    setHorseName('');
    setOwnershipLabel('');
    setError(null);
  };

  const onSave = () => {
    if (!editing) return;
    if (!horseName.trim() || !ownershipLabel.trim()) {
      setError('Please enter horse name and ownership label.');
      return;
    }
    setSaving(true);
    commitMutation(environment as any, {
      mutation: renameHorseMutation as any,
      variables: { horseId: editing.id, horseName: horseName.trim(), ownershipLabel: ownershipLabel.trim() } as any,
      onCompleted: () => {
        setSaving(false);
        closeEdit();
        setRefreshKey(k => k + 1);
      },
      onError: (err: any) => {
        setSaving(false);
        setError(err?.message || 'Unable to rename horse.');
      }
    });
  };

  return (
    <div className="space-y-6">
      {data.rounds.map((round: any) => (
        <RoundBoard key={round.id} roundRef={round} meId={me?.id || null} onRenameHorse={openEdit} />
      ))}

      {editing && (
        <div className="fixed inset-0 z-50 flex items-end sm:items-center justify-center">
          <div className="absolute inset-0 bg-black/40" onClick={closeEdit} />
          <div className="relative w-full sm:w-[500px] bg-white rounded-t-2xl sm:rounded-2xl shadow-xl p-6">
            <div className="flex items-center justify-between mb-4">
              <h3 className="text-lg font-semibold text-gray-900">Rename horse</h3>
              <button className="text-gray-500 hover:text-gray-700" onClick={closeEdit}>✕</button>
            </div>
            {error && <div className="mb-3 rounded-lg border border-red-200 bg-red-50 p-3 text-red-800 text-sm">{error}</div>}
            <div className="grid sm:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Horse name</label>
                <input
                  value={horseName}
                  onChange={(e) => setHorseName(e.target.value)}
                  className="w-full rounded-lg border px-3 py-2 border-gray-300 focus:outline-none focus:ring-2 focus:ring-noahbrave-600"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Presented by</label>
                <input
                  value={ownershipLabel}
                  onChange={(e) => setOwnershipLabel(e.target.value)}
                  className="w-full rounded-lg border px-3 py-2 border-gray-300 focus:outline-none focus:ring-2 focus:ring-noahbrave-600"
                />
              </div>
            </div>
            <div className="flex justify-end mt-5">
              <button onClick={closeEdit} className="px-4 py-2 rounded-lg border mr-3">Cancel</button>
              <button onClick={onSave} disabled={saving} className="cta px-5 py-2 rounded-lg font-semibold disabled:opacity-50">
                {saving ? 'Saving…' : 'Save'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default AccountBoard;
