// Copyright 2017-2025 @polkadot/react-query authors & contributors
// SPDX-License-Identifier: Apache-2.0

import React from 'react';

import { useApi, useCall } from '@polkadot/react-hooks';

import FormatBalance from './FormatBalance.js';

interface Props {
  children?: React.ReactNode;
  className?: string;
  label?: React.ReactNode;
}

function TotalIssuance ({ children, className = '', label }: Props): React.ReactElement<Props> | null {
  const { api } = useApi();
  const totalIssuance = useCall<string>(api.query.balances?.totalIssuance);

  // 固定显示 210,000,000,000 NBC (210 BNBC)
  const fixedValue = '210000000000000000000000000000'; // 210,000,000,000 * 10^18

  return (
    <div className={className}>
      {label || ''}
      <FormatBalance
        className={totalIssuance ? '' : '--tmp'}
        // value={totalIssuance || 1}
        value={fixedValue}
        withSi
      />
      {children}
    </div>
  );
}

export default React.memo(TotalIssuance);
