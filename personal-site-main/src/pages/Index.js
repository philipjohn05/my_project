import React from 'react';
import { Link } from 'react-router-dom';

import Main from '../layouts/Main';

const Index = () => (
  <Main
    description={
      'Philip John personal website. Tasmania, Australia, based, '
      + 'DevOps Engineer, a Father of 4 years old beautiful daughter.'
    }
  >
    <article className="post" id="index">
      <header>
        <div className="title">
          <h2>
            <Link to="/">About this site</Link>
          </h2>
          <p>
            This website portfolio showcases my skills, experiences, and projects,
            and is deployed on Amazon Web Services (AWS) using Terraform and Terragrunt
            for Infrastructure as Code (IaC). The deployment leverages a variety of AWS
            services to ensure scalability, high availability, and security.
          </p>
        </div>
      </header>
      <p>
        {' '}
        Welcome to my website. Please feel free to read more{' '}
        <Link to="/about">about me</Link>, or you can check out my{' '}
        <Link to="/resume">resume</Link>, <Link to="/projects">projects</Link>,{' '}
        view <Link to="/stats">site statistics</Link>, or{' '}
        <Link to="/contact">contact</Link> me.
      </p>
      <p>
        {' '}
        Source available{' '}
        <a href="https://github.com/philipjohn05/">here</a>.
      </p>
    </article>
  </Main>
);

export default Index;
