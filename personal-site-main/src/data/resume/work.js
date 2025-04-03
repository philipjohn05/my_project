/**
 * @typedef {Object} Position
 * Conforms to https://jsonresume.org/schema/
 *
 * @property {string} name - Name of the company
 * @property {string} position - Position title
 * @property {string} client - Company Client
 * @property {string} startDate - Start date of the position in YYYY-MM-DD format
 * @property {string|undefined} endDate - End date of the position in YYYY-MM-DD format.
 * If undefined, the position is still active.
 * @property {string|undefined} summary - html/markdown summary of the position
 * @property {string[]} highlights - plain text highlights of the position (bulleted list)
 */
const work = [
  {
    name: 'NCS PTE LTD',
    position: 'DevOps Engineer - Client (Ministry of Home Affairs)',
    startDate: '2024-07-01',
    endDate: '2025-01-05',
    highlights: [
      'Automated AWS infrastructure provisioning using Terraform, managing VPCs, EC2, S3, IAM roles, security groups and EKS clusters.',
      'Managed containerized applications using AWS EKS, configuring node groups, auto-scaling policies, and integrating with Gitlab CI/CD for seamless deployment.',
      'Designed and maintained CI/CD pipelines and Gitlab, automating build, test, and deployment processes for containerized and traditional applications.',
      'Implemented IAM roles and security policies, ensuring compliance with AWS security best practices and governance requirements.',
      'Configured AWS Auto Scaling and CloudWatch monitoring, improving fault tolerance and high availability.',
      'Optimized cloud costs by adjusting instance types, EBS volumes, and leveraging AWS Trusted Advisor recommendations.',
      'Developed infrastructure automation scripts using AWS Lambda and CloudWatch Events for log retention, system patching, and backups.',
      'Managed a multi-account AWS organization using AWS Organizations and Control Tower for centralized governance.',
    ],
  },
  {
    name: 'NCS PTE LTD',
    position: 'DevOps Engineer / Infrastructure Engineer - Client (Development Bank Of Singapore)',
    startDate: '2020-07-01',
    endDate: '2023-09-05',
    highlights: [
      'Led architecture reviews, ensuring compliance with corporate standards.',
      'Managed CI/CD pipeline, application security reviews, and deployment tools for critical projects.',
      'Monitored and maintained CI platform stability and application deployments.',
      'Successfully delivered large-scale projects such as Integrated Payment Engine 8 (IPE8).',
    ],
  },
  {
    name: 'Boston Software Solutions International Pte Ltd',
    position: 'DevOps Engineer / Infrastructure Engineer - Client (Development Bank Of Singapore)',
    startDate: '2026-04-01',
    endDate: '2019-12-05',
    highlights: [
      'Led architecture reviews, ensuring compliance with corporate standards.',
      'Managed CI/CD pipeline, application security reviews, and deployment tools for critical projects.',
      'Monitored and maintained CI platform stability and application deployments.',
      'Successfully delivered large-scale projects such as Integrated Payment Engine 8 (IPE8).',
    ],
  },
  {
    name: 'UST Global PTE LTD',
    position: 'DevOps Engineer / Infrastructure Engineer - Client (Development Bank Of Singapore)',
    startDate: '2023-02-01',
    endDate: '2016-03-05',
    highlights: [
      'Managed software deployments, configuration changes, and build automation for banking applications.',
      'Provided on-call support and technical guidance during major release implementations.',
      'Collaborated with developers and cross-functional teams to streamline build and release processes.',
    ],
  },
];

export default work;
