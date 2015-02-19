Pod::Spec.new do |s|
  s.name = 'STV+CoreData'
  s.version = '3.3.0'
  s.platform = :ios
  s.ios.deployment_target = '5.0'
  s.prefix_header_file = 'STV+CoreData/STV+CoreData-Prefix.pch'
  s.source_files = 'STV+CoreData/*.{h,m}'
  s.requires_arc = true
end
