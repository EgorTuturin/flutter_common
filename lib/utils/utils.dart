String stableOperationSystemText(String osName) {
  if (osName == null) {
    return 'Unknown';
  }

  if (osName.contains('Windows')) {
    return 'Windows';
  } else if (osName.contains('Linux')) {
    return 'Linux';
  } else if (osName.contains('Mac OS X')) {
    return 'MacOSX';
  }
  return 'Unknown';
}
