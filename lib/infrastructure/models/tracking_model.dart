class TrackingStep {
  final DateTime timestamp;
  final String description;
  final String location;

  TrackingStep({
    required this.timestamp,
    required this.description,
    required this.location,
  });
}

class TrackingInfo {
  final String currentStatus;
  final String estimatedDelivery;
  final List<TrackingStep> steps;

  TrackingInfo({
    required this.currentStatus,
    required this.estimatedDelivery,
    required this.steps,
  });
}

class InvoiceDownloadInfo {
  final String invoicePath;
  final String fileName;
  final DateTime downloadedAt;

  InvoiceDownloadInfo({
    required this.invoicePath,
    required this.fileName,
    required this.downloadedAt,
  });

  factory InvoiceDownloadInfo.fromJson(Map<String, dynamic> json) {
    return InvoiceDownloadInfo(
      invoicePath: json['invoicePath'],
      fileName: json['fileName'],
      downloadedAt: DateTime.parse(json['downloadedAt']),
    );
  }
}