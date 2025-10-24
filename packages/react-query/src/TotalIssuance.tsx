// Copyright 2017-2025 @polkadot/react-query authors & contributors
// SPDX-License-Identifier: Apache-2.0

import React from 'react';

interface Props {
  children?: React.ReactNode;
  className?: string;
  label?: React.ReactNode;
}

function TotalIssuance ({ children, className = '', label }: Props): React.ReactElement<Props> | null {
  // 硬编码显示 210,000,000,000 NBC
  const fixedDisplayValue = '210,000,000,000 NBC';

  return (
    <div className={className}>
      {label || ''}
      <span className="ui--FormatBalance">
        <span className="ui--FormatBalance-value --digits">
          {fixedDisplayValue}
        </span>
      </span>
      {children}
    </div>
  );
}

export default React.memo(TotalIssuance);
