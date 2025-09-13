const skills = [
  {
    title: 'GitLab',
    competency: 4,
    category: ['CI/CD'],
  },
  {
    title: 'Github Actions',
    competency: 4,
    category: ['CI/CD'],
  },
  {
    title: 'Jenkins',
    competency: 4,
    category: ['CI/CD'],
  },
  {
    title: 'Bamboo',
    competency: 4,
    category: ['CI/CD'],
  },
  {
    title: 'Docker',
    competency: 4,
    category: ['Containerization and Orchestration'],
  },
  {
    title: 'Terraform',
    competency: 3,
    category: ['Automation'],
  },
  {
    title: 'Ansible',
    competency: 3,
    category: ['Automation'],
  },
  {
    title: 'AWS EKS',
    competency: 3,
    category: ['Containerization and Orchestration'],
  },
  {
    title: 'AWS ECS',
    competency: 3,
    category: ['Containerization and Orchestration'],
  },
  {
    title: 'OpenShift',
    competency: 3,
    category: ['Containerization and Orchestration', 'Tools'],
  },
  {
    title: 'Bash',
    competency: 3,
    category: ['Tools', 'Languages'],
  },
  {
    title: 'Shell',
    competency: 3,
    category: ['Tools', 'Languages'],
  },
  {
    title: 'Amazon Web Services',
    competency: 4,
    category: ['Web Development', 'Tools'],
  },
  {
    title: 'ElasticSearch',
    competency: 3,
    category: ['Web Development', 'Databases'],
  },
  {
    title: 'PostgreSQL',
    competency: 2,
    category: ['Web Development', 'Databases', 'Languages'],
  },
  {
    title: 'YAML',
    competency: 3,
    category: ['Web Development', 'Languages'],
  },
  {
    title: 'Redis',
    competency: 2,
    category: ['Web Development', 'Databases'],
  },
  {
    title: 'Kubernetes',
    competency: 4,
    category: ['Tools', 'Containerization and Orchestration'],
  },
  {
    title: 'AWS',
    competency: 3,
    category: ['Tools', 'Web Development'],
  },

  {
    title: 'AWS Lambda',
    competency: 3,
    category: ['Tools', 'Web Development'],
  },
  {
    title: 'Python',
    competency: 3,
    category: ['Languages'],
  },
  {
    title: 'Apache',
    competency: 3,
    category: ['Middleware'],
  },
  {
    title: 'Nginx',
    competency: 3,
    category: ['Middleware'],
  },
  {
    title: 'IIS',
    competency: 2,
    category: ['Middleware'],
  },
  {
    title: 'IBM MQ Series',
    competency: 2,
    category: ['Middleware'],
  },
  {
    title: 'MySQL',
    competency: 3,
    category: ['Databases'],
  },
  {
    title: 'AWS Backup',
    competency: 3,
    category: ['Backup Automation', 'Recovery Planning'],
  },
  {
    title: 'Veeam',
    competency: 3,
    category: ['Backup Automation', 'Recovery Planning'],
  },
  {
    title: 'Prometheus',
    competency: 3,
    category: ['Monitoring'],
  },
  {
    title: 'AWS CloudWatch',
    competency: 3,
    category: ['Monitoring'],
  },
  {
    title: 'Grafana',
    competency: 3,
    category: ['Monitoring'],
  },
  {
    title: 'Git',
    competency: 3,
    category: ['Version Control'],
  },
  {
    title: 'GitHub',
    competency: 3,
    category: ['Version Control'],
  },
  {
    title: 'Gitlab',
    competency: 3,
    category: ['Version Control'],
  },
  {
    title: 'Bitbucket',
    competency: 3,
    category: ['Version Control'],
  },
].map((skill) => ({ ...skill, category: skill.category.sort() }));

// this is a list of colors that I like. The length should be === to the
// number of categories. Re-arrange this list until you find a pattern you like.
const colors = [
  '#6968b3',
  '#37b1f5',
  '#40494e',
  '#515dd4',
  '#e47272',
  '#cc7b94',
  '#3896e2',
  '#c3423f',
  '#d75858',
  '#747fff',
  '#64cb7b',
];

const categories = [...new Set(skills.flatMap(({ category }) => category))]
  .sort()
  .map((category, index) => ({
    name: category,
    color: colors[index],
  }));

export { categories, skills };
